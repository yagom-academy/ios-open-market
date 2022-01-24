//
//  ImageDetailCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/22.
//

import UIKit

class ImageDetailCell: UICollectionViewCell {
    
    static let identifier = "imageDetailCell"
    static let nibName = "ImageDetailCell"

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
