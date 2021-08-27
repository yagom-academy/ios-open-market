//
//  OpenMarketItemCell.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

class OpenMarketItemCell: UICollectionViewCell, StrockText, DigitStyle {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    var onReuse: () -> () = { }
}

extension OpenMarketItemCell {
    
    //MARK: Method
    func configure(item: OpenMarketItems.Item, thumnail: UIImage) {
        
        titleLabel.text = item.title
        itemImage.image = thumnail
        
        if item.stock == 0 {
            statusLabel.text = "품절"
            statusLabel.textColor = .systemYellow
        } else {
            let stock = apply(to: item.stock)
            statusLabel.textColor = .systemGray
            statusLabel.text = "잔여수량: \(stock)"
        }
        
        if let discountedPrice = item.discountedPrice {
            
            discountedPriceLabel.textColor = .systemGray
            discountedPriceLabel.text = "\(item.currency) \(apply(to: discountedPrice))"
            let strockText = strock(text: "\(item.currency)" + apply(to: item.price))
            priceLabel.attributedText = strockText
            priceLabel.textColor = .systemRed
        } else {
            discountedPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray
            priceLabel.text = "\(item.currency) \(apply(to: item.price))"
        }
        
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        itemImage.image = nil
        
        titleLabel.text = nil
        
        priceLabel.attributedText = nil
        priceLabel.text = nil
        priceLabel.textColor = .black
        
        discountedPriceLabel.textColor = .black
        discountedPriceLabel.text = nil
        discountedPriceLabel.isHidden = false
        
        statusLabel.textColor = .black
        statusLabel.text = nil
        
        onReuse()
    }
}
