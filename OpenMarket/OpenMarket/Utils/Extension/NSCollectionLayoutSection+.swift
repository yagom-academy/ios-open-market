//
//  NSCollectionLayoutSection+.swift
//  OpenMarket
//
//  Created by papri, Tiana on 31/05/2022.
//

import UIKit

extension NSCollectionLayoutSection {
    static func setUpSection(itemContentInsets: NSDirectionalEdgeInsets? = nil,
                      groupSize: NSCollectionLayoutSize,
                      orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior? = nil)
    -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        if let itemContentInsets = itemContentInsets {
            item.contentInsets = itemContentInsets
        }
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let customedSection = NSCollectionLayoutSection(group: group)
        
        if let orthogonalScrollingBehavior = orthogonalScrollingBehavior {
            customedSection.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        }
        customedSection.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
        
        return customedSection
    }
}
