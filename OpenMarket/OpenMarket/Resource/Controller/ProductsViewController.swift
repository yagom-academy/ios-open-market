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
        static let productsRowCount: Int = 200
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
    private var currentPage: Int = 1
    private var selectedLayout: LayoutType = .list

    private var productsData: ProductListResponse? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = selectedLayout.rawValue
        segment.addTarget(self, action: #selector(didChangedSegmentIndex(_:)), for: .valueChanged)

        return segment
    }()
    
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
        view = collectionView
        fetchData()
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
}

// MARK: UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return productsData?.products.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let products = productsData?.products else { return UICollectionViewCell() }
        
        let product = products[indexPath.row]
        switch selectedLayout {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListItemCell.identifier,
                for: indexPath
            ) as? ProductListItemCell else {
                return UICollectionViewCell()
            }
            cell.configureStyle()
            cell.configureLayout()
            cell.titleLabel.text = product.name
            cell.setPriceLabel(
                originPrice: product.originPriceStringValue,
                bargainPrice: product.bargainPriceStringValue,
                segment: selectedLayout.rawValue
            )
            cell.setStockLabelValue(stock: product.stock)
            
            guard let url = URL(string: product.thumbnail) else { return cell }
            let imageTask = URLSession.createTask(url: url) { image in
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }
            
            cell.task = imageTask
            return cell
            
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductGridItemCell.identifier,
                for: indexPath
            ) as? ProductGridItemCell else {
                return UICollectionViewCell()
            }
            cell.configureStyle()
            cell.configureLayout()
            cell.titleLabel.text = product.name
            cell.setPriceLabel(
                originPrice: product.originPriceStringValue,
                bargainPrice: product.bargainPriceStringValue,
                segment: selectedLayout.rawValue
            )
            cell.setStockLabelValue(stock: product.stock)
            
            guard let url = URL(string: product.thumbnail) else { return cell }
            let imageTask = URLSession.createTask(url: url) { image in
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }
            
            cell.task = imageTask
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
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = .systemPink
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Business Login
private extension ProductsViewController {
    func fetchData() {
        let endPoint = OpenMarketAPI.productsList(pageNumber: currentPage, rowCount: Constant.productsRowCount)
        productResponseNetworkManager.fetchData(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                self.productsData = data
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
}

// MARK: URLSession +
private extension URLSession {
    static func createTask(
        url: URL,
        completion: @escaping (UIImage?) -> Void
    ) -> URLSessionDataTask {
        Self.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
        }
    }
}
