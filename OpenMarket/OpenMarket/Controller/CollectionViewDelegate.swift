//
//  CollectionViewDelegate.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/16.
//

import UIKit

class CollectionViewDelegate: NSObject, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(indexPath.row)
    }
}
