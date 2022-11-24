//
//  OpenMarket - ListCollectionViewCell.swift
//  Created by Zhilly, Dragon. 22/11/22
//  Copyright © yagom. All rights reserved.
//

import UIKit
import Foundation

class ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImage.image = nil
        productNameLabel.text = ""
        priceLabel.attributedText = nil
        priceLabel.text = ""
        priceLabel.textColor = .gray
        stockLabel.text = ""
        stockLabel.textColor = .gray
    }
    
    func configurationCell(item: Product) {
        let priceText: String = item.currency.symbol + " " + String(item.price)
        let bargainText: String = item.currency.symbol + " " + String(item.bargainPrice)
        
        productNameLabel.text = item.name
        
        if priceText == bargainText {
            priceLabel.text = priceText
        } else {
            priceLabel.text = priceText + "  " + bargainText
            priceLabel.attributedText = priceLabel.text?.strikeThrough(length: priceText.count, color: .red)
        }

        if item.stock > 0 {
            stockLabel.text = "잔여수량 : \(item.stock)"
        } else {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        }
        
        if let url = URL(string: item.thumbnail) {
            productImage.load(url: url)
        }
    }
    
    func addBottomLine(color: UIColor, width: CGFloat) {
        let bottomLine: CALayer = CALayer()
        
        bottomLine.frame = CGRectMake(0, self.frame.height - width, self.frame.width, width)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
}
