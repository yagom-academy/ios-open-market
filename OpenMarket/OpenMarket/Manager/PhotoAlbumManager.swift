//
//  PhotoAlbumManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/13.
//

import UIKit
import Photos.PHAsset

struct PhotoAlbumManager {
    func convertPhotoAlbumImage() -> [UIImage] {
        let fetchOptions = PHFetchOptions()
        var images: [UIImage] = []
        let allPhotos: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        for index in 0...allPhotos.count - 1 {
            let convertImage = assetToImage(asset: allPhotos.object(at: index))
            images.append(convertImage)
        }
        return images
    }
    
    private func assetToImage(asset: PHAsset) -> UIImage {
        var resultImage = UIImage()
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: options) { image, _ in
            guard let image = image else { return }
            resultImage = image
        }
        return resultImage
    }
}
