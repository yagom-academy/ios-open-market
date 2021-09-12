//
//  PhotoAlbumCollecionViewDatasource.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit
import Photos

class PhotoAlbumCollecionViewDataSource: NSObject {
    private var allPhotos: PHFetchResult<PHAsset>?
    
    func requestPhotoAlbum() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            default:
                print("error")
            }
        }
    }
}

extension PhotoAlbumCollecionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAlbumCell.identifier, for: indexPath) as? PhotoAlbumCell else { return UICollectionViewCell() }
        
        guard let asset = allPhotos?.object(at: indexPath.item) else { return UICollectionViewCell() }
        cell.configure(asset: asset)
        
        return cell
    }
}
