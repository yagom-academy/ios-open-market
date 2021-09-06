//
//  CompositionalLayout.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/06.
//

import UIKit

struct CompositionalLayout {

    enum ScrollDirection {
        case horizontal
        case vertical
    }

    func creat(horizontalNumber: CGFloat, verticalSize: CGFloat, scrollDirection: ScrollDirection) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (_, _ ) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/horizontalNumber), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(verticalSize))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            if scrollDirection == .horizontal {
                section.orthogonalScrollingBehavior = .continuous
            }
//            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
        return layout
    }
}
