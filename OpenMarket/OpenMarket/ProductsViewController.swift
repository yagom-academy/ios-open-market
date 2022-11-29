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
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "GridCell")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        setupCollectionViewConstraints()
    }
    
    private func fetchData(_ completion: @escaping () -> Void) {
        let productListRequest = ProductListRequest(pageNo: pageNumber, itemsPerPage: 20)
        guard let url = productListRequest.request?.url else { return }
        
        networkManager.fetchData(for: url, dataType: ProductList.self) { [weak self] result in
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
        let productList = productLists[indexPath.section]
        
        switch segmentedControl.selectedSegmentIndex {
        case LayoutType.list.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",
                                                                    for: indexPath) as? ListCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configureCell(from: productList.pages[indexPath.item])
            return cell
            
        case LayoutType.grid.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell",
                                                                    for: indexPath) as? GridCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configureCell(from: productList.pages[indexPath.item])
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
}
