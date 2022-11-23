//
//  LayoutMaker.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/23.
//

import UIKit

enum LayoutMaker {
    static func make(of layout: CollectionViewLayout) -> UICollectionViewLayout {
        switch layout {
        case .list:
            return makeListLayout()
        case .grid:
            return makeGridLayout()
        }
    }
    
    private static func makeListLayout() -> UICollectionViewLayout {
        let config: UICollectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private static func makeGridLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = CGFloat(10)
        let itemCountOfColumn: Int = 2
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: .zero,
                                                     leading: spacing,
                                                     bottom: .zero,
                                                     trailing: .zero)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.87))
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: itemCountOfColumn)
        group.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                      leading: .zero,
                                                      bottom: .zero,
                                                      trailing: spacing)
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: .zero,
                                                        leading: .zero,
                                                        bottom: spacing,
                                                        trailing: .zero)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
