//
//  ItemTableViewCell.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/03.
//

import Foundation
import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDiscountedPrice: UILabel!
    @IBOutlet weak var itemStock: UILabel!
    
    func setUpView(with data: Item) {
        itemTitle.text = data.title
        itemPrice.text = "\(data.currency) \(String(data.price))"
        if let discountedPrice = data.discountedPrice {
            itemDiscountedPrice.isHidden = false
            
            let cancelPrice = "\(data.currency) \(String(discountedPrice))"
            let attributeString = NSMutableAttributedString(string: cancelPrice)
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            itemDiscountedPrice.attributedText = attributeString
        }
        else {
            itemDiscountedPrice.isHidden = true
        }
        
        if data.stock == 0 {
            itemStock.textColor = .orange
            itemStock.text = "품절"
        }
        else {
            itemStock.textColor = .systemGray2
            itemStock.text = "잔여수량 : \(String(data.stock))"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemTitle.text = nil
        itemPrice.text = nil
        itemDiscountedPrice.text = nil
        itemStock.text = nil
    }
}
