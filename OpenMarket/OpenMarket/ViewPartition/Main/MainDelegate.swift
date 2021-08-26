//
//  MainFrameLayout.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let marginX: CGFloat = 10
        let cellCountInARow: CGFloat = 2
        let cellWidth = (totalWidth - marginX) / cellCountInARow
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
