//
//  OpenMarket - ListCollectionViewCell.swift
//  Created by Zhilly, Dragon. 22/11/22
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bargainPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImage.image = nil
        productNameLabel.text = ""
        priceLabel.attributedText = nil
        priceLabel.text = ""
        priceLabel.textColor = .gray
        bargainPriceLabel.text = ""
        stockLabel.text = ""
        stockLabel.textColor = .gray
    }
    
    func configurationCell(item: Product) {
        productNameLabel.text = item.name
        priceLabel.text = "\(item.currency.symbol) \(item.price)"

        if item.price != item.bargainPrice {
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            priceLabel.textColor = .red
            
            bargainPriceLabel.text = "\(item.currency.symbol) \(item.bargainPrice)"
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
}
