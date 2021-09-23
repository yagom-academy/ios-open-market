//
//  PhotoAlbumCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit
import Photos.PHAsset

class PhotoAlbumCell: UICollectionViewCell {
    @IBOutlet private weak var photoAlbumImage: UIImageView!
    @IBOutlet weak var highlightIndicator: UIView!
    @IBOutlet weak var selectIndicator: UIImageView!
    
    static let identifier = "PhotoAlbumCell"
    static let nibName = "PhotoAlbumCell"
    private var currentImage: UIImage?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoAlbumImage.contentMode = .scaleAspectFill
    }
    
    func configure(image: UIImage) {
        self.photoAlbumImage.image = image
        currentImage = image
    }
    
    func getCurrentImage() -> UIImage? {
        return currentImage
    }
}
