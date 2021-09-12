//
//  UIImageView.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit
import Photos.PHAsset

extension UIImageView {
 func fetchImage(asset: PHAsset, targetSize: CGSize) {
    let options = PHImageRequestOptions()
    options.version = .original
    PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
        guard let image = image else { return }
        self.contentMode = .scaleToFill
        self.image = image
    }
   }
}
