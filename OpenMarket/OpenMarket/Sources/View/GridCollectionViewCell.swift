//
//  OpenMarket - ListCollectionViewCell.swift
//  Created by Zhilly, Dragon. 22/11/22
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell, CellIdentifierInfo {
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
        
        productNameLabel.text = item.name
        
        showPrice(currency: item.currency, price: item.price, bargainPrice: item.bargainPrice)
        showStock(stock: item.stock)
        showImage(thumbnail: item.thumbnail)
    }
    
    func addBorderLine(color: UIColor, width: CGFloat) {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    private func showPrice(currency: Currency, price: Double, bargainPrice: Double) {
        let priceText: String = currency.symbol + " " + price.convertNumberFormat()
        let bargainText: String = currency.symbol + " " + bargainPrice.convertNumberFormat()
        
        if priceText == bargainText {
            priceLabel.text = priceText
        } else {
            priceLabel.text = priceText + NameSpace.nextLine.text + bargainText
            priceLabel.attributedText = priceLabel.text?.strikeThrough(length: priceText.count, color: .red)
        }
    }
    
    private func showStock(stock: Int) {
        if stock > 0 {
            stockLabel.text = "잔여수량 : \(stock)"
        } else {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        }
    }
    
    private func showImage(thumbnail: String) {
        if let url = URL(string: thumbnail) {
            productImage.load(url: url)
        }
    }
}
