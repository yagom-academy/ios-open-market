//
//  OpenMarket - ProductsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProductsViewController: UIViewController {
    private enum LayoutType {
        case list
        case grid
        
        var index: Int {
            switch self {
            case .list:
                return 0
            case .grid:
                return 1
            }
        }
    }
    
    private var networkManager = NetworkManager()
    private var productLists: [ProductList] = []
    private var pageNumber: Int = 1
    private var isInfiniteScroll: Bool = true
    
    private let listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let gridCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "GridCell")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = LayoutType.list.index
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
        listCollectionView.collectionViewLayout = makeLayout(.list)
        gridCollectionView.collectionViewLayout = makeLayout(.grid)
        
        view.addSubview(gridCollectionView)
        view.addSubview(listCollectionView)
        setupCollectionViewConstraints()
        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        
        fetchData() {
            DispatchQueue.main.async { [weak self] in
                self?.gridCollectionView.reloadData()
                self?.listCollectionView.reloadData()
            }
        }
    }
    
    private func makeLayout(_ layoutType: LayoutType) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        switch layoutType {
        case .list:
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 12)
            layout.minimumLineSpacing = 0
        case .grid:
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 20,
                                     height: UIScreen.main.bounds.height / 3)
            layout.sectionInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        }
        return layout
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
            listCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    private func addTarget() {
        segmentedControl.addTarget(self, action: #selector(changeLayout(_:)), for: .valueChanged)
        addProductButton.target = self
        addProductButton.action = #selector(addNewProduct)
    }
    
    @objc private func addNewProduct() {
        let viewController = AddProductViewController()
        present(viewController, animated: true)
    }
    
    @objc private func changeLayout(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case LayoutType.list.index:
            gridCollectionView.isHidden = true
            listCollectionView.isHidden = false
            listCollectionView.reloadData()
        case LayoutType.grid.index:
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
            gridCollectionView.reloadData()
        default:
            break
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
        let productList = productLists[indexPath.section]
        
        switch segmentedControl.selectedSegmentIndex {
        case LayoutType.list.index:
            guard let cell = listCollectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",
                                                                    for: indexPath) as? ListCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configureCell(from: productList.pages[indexPath.item])
            return cell
            
        case LayoutType.grid.index:
            guard let cell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: "GridCell",
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
        
//        switch scrollView {
//        case listCollectionView:
//            gridCollectionView.contentOffset.y = scrollView.contentOffset.y * 2.1
//        case gridCollectionView:
//            listCollectionView.contentOffset.y = scrollView.contentOffset.y / 2.1
//        default:
//            break
//        }
        
        if isEndOfScroll, isInfiniteScroll {
            isInfiniteScroll = false
            pageNumber += 1
            fetchData() {
                DispatchQueue.main.async { [weak self] in
                    self?.listCollectionView.reloadData()
                    self?.gridCollectionView.reloadData()
                    self?.isInfiniteScroll = true
                }
            }
        }
    }
}
