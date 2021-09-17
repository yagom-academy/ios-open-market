//
//  PhotoAlbumCollectionViewDelegate.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/13.
//

import UIKit

class PhotoAlbumCollectionViewDelegate: NSObject {
    private var selectIndexPathDictionary: [IndexPath: Bool] = [:]
    
    func selectPhotoIndex() -> [Int] {
        var needIndexPath: [Int] = []
        for (key, value) in selectIndexPathDictionary {
            if value {
                needIndexPath.append(key.item)
            }
        }
        return needIndexPath
    }
}

extension PhotoAlbumCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoAlbumCell
        if cell?.highlightIndicator.isHidden == true && selectPhotoIndex().count < 5 {
            selectIndexPathDictionary[indexPath] = true
            cell?.highlightIndicator.isHidden = false
            cell?.selectIndicator.isHidden = false
           
        } else {
            selectIndexPathDictionary[indexPath] = false
            cell?.highlightIndicator.isHidden = true
            cell?.selectIndicator.isHidden = true
           
        }
    }
}
