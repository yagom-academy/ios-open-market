//
//  PhotoAlbumCollectionViewDelegate.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/13.
//

import UIKit

class PhotoAlbumCollectionViewDelegate: NSObject {
    private var selectIndexPathDictionary: [IndexPath: Bool] = [:]
    
    func selectPhotoIndext() -> [IndexPath] {
        var needIndexPaths: [IndexPath] = []
        for (key, value) in selectIndexPathDictionary {
            if value {
                needIndexPaths.append(key)
            }
        }
        return needIndexPaths
    }
}

extension PhotoAlbumCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoAlbumCell
        if cell?.highlightIndicator.isHidden == true {
            cell?.highlightIndicator.isHidden = false
            cell?.selectIndicator.isHidden = false
            selectIndexPathDictionary[indexPath] = true
            
        } else {
            cell?.highlightIndicator.isHidden = true
            cell?.selectIndicator.isHidden = true
            selectIndexPathDictionary[indexPath] = false
        }
    }
}
