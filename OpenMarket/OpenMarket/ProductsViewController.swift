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
    }
    
    private var networkManager = NetworkManager()
    private var productLists: [ProductList] = []
    private var pageNumber: Int = 1
    private var isInfiniteScroll: Bool = true
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
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
        self.navigationItem.rightBarButtonItem = self.addProductButton
        collectionView.collectionViewLayout = makeLayout(.list)
        
        view.addSubview(collectionView)
        setupListConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchData() {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func makeLayout(_ layoutType: LayoutType) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        switch layoutType {
        case .list:
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        case .grid:
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 20,
                                     height: UIScreen.main.bounds.width / 2)
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
    
    private func setupListConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",
                                                            for: indexPath) as? ListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let productList = productLists[indexPath.section]
        cell.configureCell(from: productList.pages[indexPath.item])
        
        return cell
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
