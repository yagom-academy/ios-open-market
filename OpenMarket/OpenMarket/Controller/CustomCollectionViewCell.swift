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
    
    func configure(item: ItemData) {
        item.image { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        titleLabel.text = item.title
        priceLabel.text = "\(item.currency) \(item.price.description)"
        discountedPriceLabel.text = "\(item.currency) \(item.discountedPrice?.description)"
        
        if item.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else if item.stock > StockAmount.Maximum.rawValue {
            stockLabel.text = "잔여수량 : \(StockAmount.Maximum.description) +"
            stockLabel.textColor = .gray
        } else {
            stockLabel.text = "잔여수량 : \(item.stock.description)"
            stockLabel.textColor = .gray
        }
    }
}
