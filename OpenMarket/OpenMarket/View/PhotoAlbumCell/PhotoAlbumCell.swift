//
//  PhotoAlbumCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit
import Photos.PHAsset

class PhotoAlbumCell: UICollectionViewCell {
    static let identifier = "photoAlbum"
    private let photoAlbumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(photoAlbumImage)
        photoAlbumImage.frame = CGRect(x: 0, y: 0,
                                       width: contentView.frame.width,
                                       height: contentView.frame.height)
    }
    
    func configure(asset: PHAsset) {
        photoAlbumImage.fetchImage(asset: asset, targetSize: photoAlbumImage.frame.size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
