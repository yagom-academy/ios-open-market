//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by kio on 2021/06/16.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.priceLabel.attributedText = nil
        self.discountedPriceLabel.isHidden = false
    }
}
