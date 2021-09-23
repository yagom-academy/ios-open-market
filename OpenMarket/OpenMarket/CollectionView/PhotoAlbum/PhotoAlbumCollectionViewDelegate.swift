//
//  PhotoAlbumCollectionViewDelegate.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/13.
//

import UIKit

class PhotoAlbumCollectionViewDelegate: NSObject {
    private var selectImageDictionary: [UIImage?: Bool] = [:]
    
    func selectPhotoImage() -> [UIImage] {
        var needIndexPath: [UIImage] = []
        for (key, value) in selectImageDictionary {
            if let key = key, value {
                needIndexPath.append(key)
            }
        }
        return needIndexPath
    }
}

extension PhotoAlbumCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoAlbumCell
        if cell?.highlightIndicator.isHidden == true &&
            selectPhotoImage().count < 5 {
            selectImageDictionary[cell?.getCurrentImage()] = true
            cell?.highlightIndicator.isHidden = false
            cell?.selectIndicator.isHidden = false
            
        } else {
            selectImageDictionary[cell?.getCurrentImage()] = false
            cell?.highlightIndicator.isHidden = true
            cell?.selectIndicator.isHidden = true
            
        }
    }
}
