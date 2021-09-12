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
    
//    override var isHighlighted: Bool {
//        didSet {
//            highlightIndicator.isHidden = !isHighlighted
//        }
//    }
//    override var isSelected: Bool {
//        didSet {
//            highlightIndicator.isHidden = !isSelected
//            selectIndicator.isHidden = !isSelected
//        }
//    }
    
    func configure(asset: PHAsset) {
        photoAlbumImage.fetchImage(asset: asset, targetSize: photoAlbumImage.frame.size)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
