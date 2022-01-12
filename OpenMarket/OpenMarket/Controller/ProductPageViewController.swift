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
            cell.configureContents(image: UIImage(named: "Image")!,
                                   productName: "MacBook Pro",
                                   price: "999.99",
                                   discountedPrice: nil,
                                   currency: .USD,
                                   stock: "100")
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Product>()
        snapShot.appendSections([0])
        snapShot.appendItems([
            Product(id: 1,
                    venderId: 1,
                    name: "1",
                    thumbnail: "1",
                    currency: .KRW,
                    price: 1,
                    bargainPrice: 1,
                    discountedPrice: 1,
                    stock: 1,
                    images: [],
                    vendors: nil,
                    createdAt: Date(timeInterval: TimeInterval(), since: .distantFuture),
                    issuedAt: Date(timeInterval: TimeInterval(), since: .distantFuture)),
            Product(id: 2,
                    venderId: 1,
                    name: "1",
                    thumbnail: "1",
                    currency: .KRW,
                    price: 1,
                    bargainPrice: 1,
                    discountedPrice: 1,
                    stock: 1,
                    images: [],
                    vendors: nil,
                    createdAt: Date(timeInterval: TimeInterval(), since: .distantFuture),
                    issuedAt: Date(timeInterval: TimeInterval(), since: .distantFuture)),
            Product(id: 3,
                    venderId: 1,
                    name: "1",
                    thumbnail: "1",
                    currency: .KRW,
                    price: 1,
                    bargainPrice: 1,
                    discountedPrice: 1,
                    stock: 1,
                    images: [],
                    vendors: nil,
                    createdAt: Date(timeInterval: TimeInterval(), since: .distantFuture),
                    issuedAt: Date(timeInterval: TimeInterval(), since: .distantFuture)),
            Product(id: 4,
                    venderId: 1,
                    name: "1",
                    thumbnail: "1",
                    currency: .KRW,
                    price: 1,
                    bargainPrice: 1,
                    discountedPrice: 1,
                    stock: 1,
                    images: [],
                    vendors: nil,
                    createdAt: Date(timeInterval: TimeInterval(), since: .distantFuture),
                    issuedAt: Date(timeInterval: TimeInterval(), since: .distantFuture)),
            Product(id: 5,
                    venderId: 1,
                    name: "1",
                    thumbnail: "1",
                    currency: .KRW,
                    price: 1,
                    bargainPrice: 1,
                    discountedPrice: 1,
                    stock: 1,
                    images: [],
                    vendors: nil,
                    createdAt: Date(timeInterval: TimeInterval(), since: .distantFuture),
                    issuedAt: Date(timeInterval: TimeInterval(), since: .distantFuture))
            
        ])
        dataSource?.apply(snapShot)
    }
}
