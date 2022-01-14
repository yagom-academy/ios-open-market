//
//  OpenMarketLayout.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

enum OpenMarketLayout {
    case list
    case grid
    
    var layout: UICollectionViewLayout {
        switch  self {
        case .list:
            let config = UICollectionLayoutListConfiguration(appearance: .plain)
            return UICollectionViewCompositionalLayout.list(using: config)
        case .grid:
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
    }
    func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, Product> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    private var cellRegistration: UICollectionView.CellRegistration<GridLayoutCell, Product> {
        UICollectionView.CellRegistration { (cell, indexPath, identifier) in
            cell.isGridLayout = self == .grid ? true : false
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
    }
}
