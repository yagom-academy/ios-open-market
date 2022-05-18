//
//  ListCell.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/18.
//

import UIKit

final class ListCell: UICollectionViewCell, ItemCellable {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bargainPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    
    var itemImage: UIImage? = UIImage(){
        didSet {
            self.itemImageView.image = itemImage
        }
    }
    
    var itemName: String = "" {
        didSet {
            self.itemNameLabel.text = itemName
        }
    }
    
    var price: String = "" {
        didSet {
            let attributeString = NSMutableAttributedString(string: price)
            
            attributeString.addAttribute(.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            
            self.priceLabel.attributedText = attributeString
        }
    }
    
    var discountedPrice: Int = 0 {
        didSet {
            if discountedPrice == 0 {
                self.priceLabel.isHidden = true
            } else {
                self.priceLabel.isHidden = false
            }
        }
    }
    
    var bargainPrice: String = "" {
        didSet {
            self.bargainPriceLabel.text = bargainPrice
        }
    }
    
    var stock: Int = 0 {
        didSet {
            if stock == 0 {
                self.stockLabel.text = "품절"
                self.stockLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            } else {
                self.stockLabel.text = "잔여수량 : \(stock)"
                self.stockLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemNameLabel.text = nil
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        stockLabel.text = nil
        stockLabel.textColor = nil
    }
}
