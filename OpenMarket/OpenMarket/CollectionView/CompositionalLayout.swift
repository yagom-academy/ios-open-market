//
//  CompositionalLayout.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/06.
//

import UIKit

struct CompositionalLayout {
    func create(portraitHorizontalNumber: Int, landscapeHorizontalNumber: Int, verticalSize: CGFloat, scrollDirection: ScrollDirection) -> UICollectionViewLayout {
        var horizontalNumber: Int {
            UIDevice.current.orientation.isPortrait ? portraitHorizontalNumber : landscapeHorizontalNumber
        }
        let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(verticalSize))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: horizontalNumber)
            let section = NSCollectionLayoutSection(group: group)
            if scrollDirection == .horizontal {
                section.orthogonalScrollingBehavior = .continuous
            }
            section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
            return section
        }
        return layout
    }
}
