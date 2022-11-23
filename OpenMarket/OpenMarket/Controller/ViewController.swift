//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    let networkManager: NetworkManager = .init()
    var dataSource: UICollectionViewDiffableDataSource<Section, ProductData>!
    var productCollectionView: UICollectionView!
    var productList: ProductListData?
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["list", "grid"])
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = segmentControl
        configureProductCollectionView()
        networkManager.loadData(of: .productList(pageNumber: 1, itemsPerPage: 100), dataType: ProductListData.self) { result in
            switch result {
            case .success(let productList):
                self.productList = productList
                DispatchQueue.main.async {
                    self.configureDataSource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureProductCollectionView() {
        let configure = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configure)
        
        productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productCollectionView)
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductCell, ProductData> { cell, indexPath, product in
            var content = UIListContentConfiguration.cell()
            content.text = product.name

            if product.stock == 0 {
                cell.stockLabel.text = "품절"
                cell.stockLabel.textColor = .systemYellow
            } else {
                cell.stockLabel.text = "잔여수량: " + product.stock.description
                cell.stockLabel.textColor = .systemGray2
            }
            
            if product.price == product.bargainPrice {
                content.secondaryText = product.currencyAndPrice
            } else {
                content.secondaryAttributedText = product.currencyAndDiscountedPrice
            }
            
            content.secondaryTextProperties.color = .systemGray2
            cell.listContentView.configuration = content
            cell.accessories = [.disclosureIndicator()]
            
            self.networkManager.loadThumbnailImage(of: product.thumbnail) { result  in
                switch result {
                case .success(let image):
                    content.image = image
                    DispatchQueue.main.async {
                        if indexPath == self.productCollectionView.indexPath(for: cell) {
                            cell.listContentView.configuration = content
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

        dataSource = UICollectionViewDiffableDataSource<Section, ProductData>(collectionView: productCollectionView) { collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productList!.pages)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
