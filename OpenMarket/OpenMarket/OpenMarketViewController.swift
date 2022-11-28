//
//  OpenMarket - OpenMarketViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    
    private enum ProductListSection: Int {
        case main
    }
    
    private enum ViewType: String, CaseIterable {
        case list = "LIST"
        case grid = "GRID"
    }
    
//    private let segmentedControl: UISegmentedControl = {
//        let control = UISegmentedControl(items: [ViewType.list.rawValue, ViewType.grid.rawValue])
//            control.translatesAutoresizingMaskIntoConstraints = false
//            return control
//    }()
    
    private var gridCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<ProductListSection, Product>?
    private var products: [Product] = [] {
        didSet {
            applySnapshot(for: products)
        }
    }
    
    private var pageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(for: pageNumber)
        configureGridCollectionView()
        configureDataSource()
    }
    
    var isLoading: Bool = false
    
    func fetchData(for page: Int) {
        guard !isLoading else { return }
        let networkManager = NetworkManager()
        isLoading = true
        networkManager.request(endpoint: OpenMarketAPI.productList(pageNumber: page, itemsPerPage: 10), dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                var refinedProducts: [Product] = []
                for product in productList.products {
                    if self.products.contains(product) { continue }
                    refinedProducts.append(product)
                }
                self.products += refinedProducts
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureGridCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let gridCollectionView = gridCollectionView else { return }
        view.addSubview(gridCollectionView)
        
        gridCollectionView.delegate = self
        
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gridCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func configureDataSource() {
        guard let gridCollectionView = gridCollectionView else { return }

        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product>(collectionView: gridCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell
            cell?.contentView.backgroundColor = .white
            cell?.contentView.layer.borderColor = UIColor.gray.cgColor
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.cornerRadius = 10.0
            cell?.contentView.layer.masksToBounds = true
            cell?.updateContents(product)
            return cell
        }
    }
    
    func applySnapshot(for items: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension OpenMarketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == products.count - 1 {
            pageNumber += 1
            fetchData(for: pageNumber)
        }
    }
}

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2 - 15
        let height: CGFloat = collectionView.frame.height / 3 - 20
        return CGSize(width: width, height: height)
    }
}
