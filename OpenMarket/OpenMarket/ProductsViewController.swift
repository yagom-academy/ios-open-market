//
//  OpenMarket - ProductsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProductsViewController: UIViewController {
    private enum LayoutType: Int, CaseIterable {
        case list = 0
        case grid
        
        var text: String {
            switch self {
            case .list:
                return "LIST"
            case .grid:
                return "GRID"
            }
        }
    }
    
    private let networkManager = NetworkManager()
    private var productLists: [ProductList] = []
    private var pageNumber: Int = 1
    private var isInfiniteScroll: Bool = true
    
    private let listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 12)
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private let gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 15,
                                 height: UIScreen.main.bounds.height / 3)
        layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 10)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: LayoutType.allCases.compactMap { $0.text })
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = LayoutType.list.rawValue
        segmentedControl.backgroundColor = .systemGray6
        return segmentedControl
    }()
    
    private let addProductButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "+"
        let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.boldSystemFont(ofSize: 16)]
        barButton.setTitleTextAttributes(attributes, for: .normal)
        return barButton
    }()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.titleView = self.segmentedControl
        addTarget()
        self.navigationItem.rightBarButtonItem = self.addProductButton
        setupCollectionView()
        
        fetchData() {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = listLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        setupCollectionViewConstraints()
    }
    
    private func fetchData(_ completion: @escaping () -> Void) {
        let productListRequest = ProductListRequest(pageNo: pageNumber, itemsPerPage: 20)
        guard let request = productListRequest.request else { return }
        
        networkManager.fetchData(from: request, dataType: ProductList.self) { [weak self] result in
            switch result {
            case .success(let productList):
                self?.productLists.append(productList)
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    private func addTarget() {
        segmentedControl.addTarget(self, action: #selector(changeLayout(_:)), for: .valueChanged)
        addProductButton.target = self
        addProductButton.action = #selector(addNewProduct)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func addNewProduct() {
        let navigationController = UINavigationController(rootViewController: AddProductViewController())
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc private func changeLayout(_ segmentedControl: UISegmentedControl) {
        let visiblePath: [IndexPath] = collectionView.indexPathsForVisibleItems.sorted()
        var index: IndexPath = IndexPath()
        
        switch segmentedControl.selectedSegmentIndex {
        case LayoutType.list.rawValue:
            index = visiblePath.count == 8 ? visiblePath[2] : visiblePath[0]
            collectionView.collectionViewLayout = listLayout
        case LayoutType.grid.rawValue:
            index = collectionView.contentOffset.y > 0 ? visiblePath[2] : visiblePath[0]
            collectionView.collectionViewLayout = gridLayout
        default:
            break
        }
        collectionView.reloadData()
        collectionView.scrollToItem(at: index, at: .top, animated: false)
    }
    
    @objc private func refresh() {
        pageNumber = 1
        productLists = []
        fetchData() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.isInfiniteScroll = true
            }
        }
    }
}

extension ProductsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productLists[valid: section]?.pages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let product = productLists[valid: indexPath.section]?.pages[valid: indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case LayoutType.list.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",
                                                                for: indexPath) as? ListCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(from: product)
            return cell
            
        case LayoutType.grid.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell",
                                                                for: indexPath) as? GridCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(from: product)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension ProductsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let endPoint: CGFloat = scrollView.contentSize.height - scrollView.bounds.height
        let isEndOfScroll: Bool = scrollView.contentOffset.y > endPoint
        
        if isEndOfScroll, isInfiniteScroll {
            isInfiniteScroll = false
            pageNumber += 1
            fetchData() {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.isInfiniteScroll = true
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = productLists[valid: indexPath.section]?.pages[valid: indexPath.item],
              let request = ProductDetailRequest(productID: product.id).request
        else { return }
        
        networkManager.fetchData(from: request, dataType: DetailProduct.self) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let detailViewController = ProductDetailViewController(data)
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
