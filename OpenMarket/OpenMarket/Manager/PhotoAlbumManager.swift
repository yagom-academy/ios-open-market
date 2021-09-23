//
//  PhotoAlbumManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/13.
//

import UIKit
import Photos.PHAsset

struct PhotoAlbumManager {
    private let allPhotos: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: PHFetchOptions())
    
    @discardableResult
    func getAllPhotos() -> PHFetchResult<PHAsset> {
        return allPhotos
    }
    
    func initializeAllphotos(collectionView: UICollectionView) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
               getAllPhotos()
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func requestImage(asset: PHAsset, cell: PhotoAlbumCell) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        PHImageManager().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: options) { (image, _) in
            if let image = image {
                cell.configure(image: image)
            }
        }
    }
}
