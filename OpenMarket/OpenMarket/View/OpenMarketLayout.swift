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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
            
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
    func createDataSource<CellType: OpenMarketCollectionViewCell>(for collectionView: UICollectionView, cellType: CellType.Type) -> UICollectionViewDiffableDataSource<Int, Product> {
        let cellRegistration = UICollectionView.CellRegistration<CellType, Product> { (cell, indexPath, item) in
            cell.configureContents(with: item)
            
            if self == .grid {
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                cell.layer.borderWidth = 1.0
            } else {
                cell.layer.borderWidth = 0.3
            }
            
            cell.layer.borderColor = UIColor.systemGray.cgColor
        }

        let dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        return dataSource
    }
}
