//
//  MarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/26.
//

import UIKit

class MarketCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemRed
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()

    func configureCell(with item: Item, spacingType: String) {
        self.nameLabel.text = item.productName
        
        if item.price == item.bargainPrice {
            self.priceLabel.text = item.price
            self.priceLabel.textColor = .systemGray
        } else {
            let price = item.price + spacingType + item.bargainPrice
            let attributeString = NSMutableAttributedString(string: price)
            
            attributeString.addAttribute(.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, item.price.count))
            attributeString.addAttribute(.foregroundColor,
                                         value: UIColor.systemGray,
                                         range: NSMakeRange(item.price.count + 1, item.bargainPrice.count))
            self.priceLabel.attributedText = attributeString
        }
        
        if item.stock != "0" {
            self.stockLabel.text = "잔여수량 : " + item.stock
        } else {
            self.stockLabel.text = "품절"
            self.stockLabel.textColor = .systemOrange
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        stockLabel.textColor = .systemGray
        priceLabel.textColor = .systemRed
    }
}
