//
//  PhotoAlbumCollectionViewDelegate.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/13.
//

import UIKit

class PhotoAlbumCollectionViewDelegate: NSObject {

}

extension PhotoAlbumCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PhotoAlbumCell
        if cell?.highlightIndicator.isHidden == true {
            cell?.highlightIndicator.isHidden = false
            cell?.selectIndicator.isHidden = false
        } else {
            cell?.highlightIndicator.isHidden = true
            cell?.selectIndicator.isHidden = true
        }
    }
}
