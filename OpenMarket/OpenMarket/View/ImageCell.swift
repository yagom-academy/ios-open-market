//
//  ImageCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/20.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with image: UIImage?) {
        self.imageView.image = image
    }
}

extension ImageCell: IdentifiableView {}
