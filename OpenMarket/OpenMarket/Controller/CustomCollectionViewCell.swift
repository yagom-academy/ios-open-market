//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/23.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10.0
        
        titleLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        discountedPriceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(item: ItemData) {
        item.image { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        titleLabel.text = item.title
        
        if let discountedPrice = item.discountedPrice {
            let priceLabelString = "\(item.currency) \(item.price.withDigit)"
            priceLabel.attributedText = priceLabelString.strikeThrough()
            priceLabel.textColor = .red
            discountedPriceLabel.text = "\(item.currency) \(discountedPrice.withDigit)"
            discountedPriceLabel.textColor = .gray
        } else {
            priceLabel.text = "\(item.currency) \(item.price.withDigit)"
            priceLabel.textColor = .gray
            discountedPriceLabel.text = nil
        }
        
        if item.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else if item.stock > StockAmount.Maximum.rawValue {
            stockLabel.text = "잔여수량 : \(StockAmount.Maximum.rawValue.withDigit) +"
            stockLabel.textColor = .gray
        } else {
            stockLabel.text = "잔여수량 : \(item.stock.withDigit)"
            stockLabel.textColor = .gray
        }
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.priceLabel.attributedText = nil
        self.priceLabel.textColor = nil
        self.stockLabel.textColor = nil
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

extension Int {
    var withDigit: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: self) ?? ""
        return result
    }
}
