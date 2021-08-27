//
//  MainFrameLayout.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    weak var superView: MainViewController?
    
    init(self superView: MainViewController) {
        self.superView = superView
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let frameHeight = scrollView.frame.height
        let verticalPosition = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - verticalPosition
        
        if frameHeight >= distanceFromBottom {
            superView?.message(requestNewItemList: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MainCell else {
            return
        }
        
        cell.show(at: collectionView, withIdentifer: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let marginX: CGFloat = 10
        let cellCountInARow: CGFloat = 2
        let cellWidth = (totalWidth - marginX) / cellCountInARow
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
