//
//  PhotoAlbumCollecionViewDatasource.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit
import Photos.PHAsset

class PhotoAlbumCollecionViewDataSource: NSObject {
    private let compositionalLayout = CompositionalLayout()
    var photoAlbumManager = PhotoAlbumManager()
}

extension PhotoAlbumCollecionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        photoAlbumManager.getAllphotos().count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAlbumCell.identifier, for: indexPath) as?
                PhotoAlbumCell else { return UICollectionViewCell() }
        
        let asset = photoAlbumManager.getAllphotos()[indexPath.item]
        photoAlbumManager.requestImage(asset: asset, cell: cell)
        
        return cell
    }
    
    func decidedListLayout(_ collectionView: UICollectionView) {
        let viewMargin =
        compositionalLayout.margin(top: 2, leading: 2, bottom: 2, trailing: 2)
        let cellMargin =
        compositionalLayout.margin(top: 1, leading: 1, bottom: 1, trailing: 1)
        collectionView.collectionViewLayout =
        compositionalLayout.create(portraitHorizontalNumber: 3,
                                   landscapeHorizontalNumber: 5,
                                   cellVerticalSize: .absolute(100),
                                   scrollDirection: .vertical,
                                   cellMargin: cellMargin, viewMargin: viewMargin)
    }
}
