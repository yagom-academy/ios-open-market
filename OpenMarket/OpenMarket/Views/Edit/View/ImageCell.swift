//
//  ImageCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/18.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "imageCell"
    static let nibName = "ImageCell"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
    }
    
    @IBAction func tappedDeleteButton(_ sender: UIButton) {
        guard let collectionView = self.superview as? ImagesCollectionView else {
            return
        }
        NotificationCenter.default.post(name: .deleteButton, object: collectionView.indexPath(for: self))
    }
}
