//
//  ImageDetailCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/22.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    static let identifier = "imageViewCell"
    static let nibName = "ImageViewCell"

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
