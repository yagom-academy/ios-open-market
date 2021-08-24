//
//  ProductListCustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/24.
//

import UIKit

class ProductListCustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    static let identifier = "ProductListCustomCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
