//
//  OpenMarketItemCell.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

class OpenMarketItemCell: UICollectionViewCell, StrockText {
 
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!

}

extension OpenMarketItemCell {
    
    func configure(item: OpenMarketItems.Item, image: UIImage) {
        titleLabel.text = item.title
        itemImage.image = image
        
        if item.stock == 0 {
            statusLabel.text = "품절"
            statusLabel.textColor = .systemYellow
        } else {
            statusLabel.text = "잔여수량: \(item.stock)"
        }
        
        if let discountedPrice = item.discountedPrice {
            discountedPriceLabel.textColor = .systemGray
            discountedPriceLabel.text = "\(item.currency) \(discountedPrice)"
            let strockLabel = strockLabel(item: String(item.price))
            priceLabel.attributedText = strockLabel
//            priceLabel = strockLabel
        } else {
            discountedPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray
            priceLabel.text = "\(item.currency) \(item.price)"
        }
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        priceLabel.text = nil
        statusLabel.textColor = .black
        statusLabel.text = nil
        
        priceLabel.textColor = .black
        discountedPriceLabel.textColor = .black
        discountedPriceLabel.text = nil
        priceLabel.attributedText = nil
        discountedPriceLabel.isHidden = false
    }
}
