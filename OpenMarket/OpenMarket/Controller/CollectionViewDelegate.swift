//
//  CollectionViewDelegate.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/13.
//

import UIKit

class CollectionViewDelegate: NSObject, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {
            return true
        }
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        } else {
            print("\(cell.priceLabel.text) -> \(cell.discountedPriceLabel.text)")
            return true
        }
    }
}
// MARK: Extension for UICollectionViewDelegateFlowLayout
extension CollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    var insetForSection: CGFloat {
        return 10
    }
    var insetForCellSpacing: CGFloat {
        return 10
    }
    var cellForEachRow: Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (insetForSection * 2 + insetForCellSpacing * (cellForEachRow - 1))) / cellForEachRow
        let height = width * 1.4
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetForCellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: insetForSection, left: insetForSection, bottom: insetForSection, right: insetForSection)
    }
}
