//
//  PhotoAlbumCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit
import Photos.PHAsset

class PhotoAlbumCell: UICollectionViewCell {
    static let identifier = "PhotoAlbumCell"
    static let nibName = "PhotoAlbumCell"
    @IBOutlet weak var photoAlbumImage: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!
    @IBOutlet weak var selectIndicator: UIImageView!

//    func configure(asset: PHAsset) {
//        photoAlbumImage.fetchImage(asset: asset, targetSize: photoAlbumImage.frame.size)
//    }
    func configure(cell: UIImage) {
        self.photoAlbumImage.image = cell
        photoAlbumImage.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
