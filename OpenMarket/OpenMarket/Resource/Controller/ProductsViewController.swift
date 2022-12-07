//
//  OpenMarket - ProductsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

// MARK: ProductsViewController
final class ProductsViewController: UIViewController {
    enum Constant {
        static let edgeInsetValue: CGFloat = 8
        static let listCellHeightRatio: Double = 0.1
        static let gridCellHeightRatio: Double = 0.3
        static let productsRowCount: Int = 20
    }
    
    enum LayoutType: Int {
        case list, grid
        
        var divideRatio: CGFloat {
            switch self {
            case .list:
                return 1
            case .grid:
                return 2
            }
        }
        
        var heightRatio: CGFloat {
            switch self {
            case .list:
                return Constant.listCellHeightRatio
            case .grid:
                return Constant.gridCellHeightRatio
            }
        }
    }
    
    private let productResponseNetworkManager = NetworkManager<ProductListResponse>()
    private var currentPageNumber: Int = 1
    private var selectedLayout: LayoutType = .list
    private var isFirstFetching: Bool = true
    private var isLoading: Bool = false
    
    private var productsData: ProductListResponse? {
        didSet {
            self.updateCollectionView()
        }
    }
    
    private var products: [Product] = [] {
        didSet {
            self.collectionView.reloadData()
            self.isFirstFetching = false
            self.isLoading = false
        }
    }
    
    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = selectedLayout.rawValue
        segment.addTarget(self, action: #selector(didChangedSegmentIndex(_:)), for: .valueChanged)
        
        return segment
    }()
    
    private var activityIndicator = UIActivityIndicatorView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(
            top: Constant.edgeInsetValue,
            left: Constant.edgeInsetValue,
            bottom: 0,
            right: Constant.edgeInsetValue
        )
        
        collectionView.register(
            ProductListItemCell.self,
            forCellWithReuseIdentifier: ProductListItemCell.identifier
        )
        
        collectionView.register(
            ProductGridItemCell.self,
            forCellWithReuseIdentifier: ProductGridItemCell.identifier
        )
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationbar()
        view = activityIndicator
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData(isUpdateAndNotFirstFetching: true && !isFirstFetching)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.bounds.size
        let contentWidth = (size.width / selectedLayout.divideRatio) - (2 * Constant.edgeInsetValue)
        let contentHeight = (size.height * selectedLayout.heightRatio)
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constant.edgeInsetValue
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constant.edgeInsetValue
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isFirstFetching {
            return
        }
        
        let position = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let scrollFrameHeight = scrollView.frame.size.height
        let targetPosition = (contentHeight - scrollFrameHeight - 20)
        
        if position > targetPosition {
            if isLoading {
                return
            }
            
            currentPageNumber += 1
            fetchData(isUpdateAndNotFirstFetching: false && !isFirstFetching)
        }
    }
}

// MARK: UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return products.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let product = products[indexPath.row]
        
        switch selectedLayout {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListItemCell.identifier,
                for: indexPath
            ) as? ProductListItemCell else {
                return UICollectionViewCell()
            }
            cell.setupCellData(product: product, index: selectedLayout.rawValue)
            
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductGridItemCell.identifier,
                for: indexPath
            ) as? ProductGridItemCell else {
                return UICollectionViewCell()
            }
            cell.setupCellData(product: product, index: selectedLayout.rawValue)
            
            return cell
        }
    }
}

// MARK: Objc Method
private extension ProductsViewController {
    @objc func didChangedSegmentIndex(_ sender: UISegmentedControl) {
        guard let type = LayoutType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        
        selectedLayout = type
        collectionView.reloadData()
    }
    
    @objc func didTappedAddButton() {
        let viewController = RegisterProductViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Business Login
private extension ProductsViewController {
    func fetchData(isUpdateAndNotFirstFetching: Bool) {
        isLoading = true
    
        let rowCount = isUpdateAndNotFirstFetching ? (currentPageNumber * Constant.productsRowCount) : Constant.productsRowCount
        let pageNumber = isUpdateAndNotFirstFetching ? 1 : currentPageNumber
        let endPoint = OpenMarketAPI.productsList(
            pageNumber: pageNumber,
            rowCount: rowCount
        )
        
        productResponseNetworkManager.fetchData(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if isUpdateAndNotFirstFetching {
                        self.products.removeAll()
                    }
                    
                    self.productsData = data
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: Configure UI
private extension ProductsViewController {
    func configureNavigationbar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTappedAddButton)
        )
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.titleView = segment
    }
    
    func updateCollectionView() {
        activityIndicator.stopAnimating()
        view = collectionView
        guard let productsSet = productsData?.products else {
            return
        }
        products.append(contentsOf: productsSet)
    }
}
