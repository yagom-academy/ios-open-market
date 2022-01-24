//
//  ImageCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/20.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Configure Methods
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with image: UIImage?) {
        self.imageView.image = image
    }
}

// MARK: - IdentifiableView

extension ImageCell: IdentifiableView {}
