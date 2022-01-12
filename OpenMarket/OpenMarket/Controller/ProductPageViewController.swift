//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductPageViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Product>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        configureDatasource()
        fetchPage(itemsPerPage: 10)
    }

}

extension ProductPageViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.3225))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<GridLayoutCell, Product> { (cell, indexPath, identifier) in
            
            cell.configureContents(imageURL: identifier.thumbnail,
                                   productName: identifier.name,
                                   price: identifier.price.description,
                                   discountedPrice: identifier.discountedPrice.description,
                                   currency: identifier.currency,
                                   stock: String(identifier.stock))
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    private func fetchPage(itemsPerPage: Int) {
        URLSessionProvider(session: URLSession.shared)
            .request(.showProductPage(pageNumber: "1", itemsPerPage: String(itemsPerPage))) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
            switch result {
            case .success(let data):
                var snapShot = NSDiffableDataSourceSnapshot<Int, Product>()
                snapShot.appendSections([0])
                snapShot.appendItems(data.pages as [Product])
                self.dataSource?.apply(snapShot)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
