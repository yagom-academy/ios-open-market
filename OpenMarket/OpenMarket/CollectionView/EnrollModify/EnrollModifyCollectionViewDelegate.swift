//
//  EnrollModifyCollectionViewDelegate.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/14.
//

import UIKit

class EnrollModifyCollectionViewDelegate: NSObject {
    private var enrollModifyCollectionViewDataSource: EnrollModifyCollectionViewDataSource?
    
    func updateEnrollModifyCollectionViewDataSource(enrollModifyCollectionViewDataSource: EnrollModifyCollectionViewDataSource) {
        self.enrollModifyCollectionViewDataSource = enrollModifyCollectionViewDataSource
    }

}
extension EnrollModifyCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let photoIndexPaths = collectionView.indexPathsForSelectedItems else { return }
            for indexPath in photoIndexPaths {
                enrollModifyCollectionViewDataSource?.photoAlbumImages.remove(at: indexPath.item - 1)
                enrollModifyCollectionViewDataSource?.medias.remove(at: indexPath.item - 1)
            }
            collectionView.deleteItems(at: photoIndexPaths)
    }
}
