//
//  OpenMarket - ListCollectionViewCell.swift
//  Created by Zhilly, Dragon. 22/11/22
//  Copyright © yagom. All rights reserved.
//

import UIKit
import Foundation

final class ListCollectionViewCell: UICollectionViewCell, CellIdentifierInfo {
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        priceLabel.attributedText = nil
        priceLabel.textColor = .gray
        stockLabel.textColor = .gray
    }
    
    func configurationCell(item: Product) {
        productImage.image = nil
        productNameLabel.text = nil
        priceLabel.text = nil
        stockLabel.text = nil
        
        let priceText: String = item.currency.symbol + " " + item.price.convertNumberFormat()
        let bargainText: String = item.currency.symbol + " " + item.bargainPrice.convertNumberFormat()
        
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
