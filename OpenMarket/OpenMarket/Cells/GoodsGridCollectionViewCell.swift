//
//  GoodsGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김호준 on 2021/02/03.
//

import UIKit

class GoodsGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        productTitleLabel.text = nil
        discountedPriceLabel.text = nil
        priceLabel.text = nil
        stockLabel.text = nil
    }
    
    //Config Cell
    public func configure(goods: Goods) {
        if let thumbnails = goods.thumbnails.first {
            thumbnailImageView.setImageWithURL(urlString: thumbnails)
        }
        if let discountedPrice = goods.discountedPrice {
            settingPriceWithDiscount(currency: goods.currency,
                                     price: goods.price,
                                     discountedPrice: discountedPrice)
        } else {
            settingPrice(currency: goods.currency, price: goods.price)
        }
        
        if goods.stock == 0 {
            settingSoldOut()
        } else {
            settingStock(with: goods.stock)
        }
    }
    
    // MARK: - setting Price UI
    private func settingPriceWithDiscount(currency: String, price: UInt, discountedPrice: UInt) {
        priceLabel.isHidden = false
        priceLabel.attributedText = PriceFormat.makePriceStringWithStrike(currency: currency, price: discountedPrice)
        priceLabel.text = PriceFormat.makePriceString(currency: currency, price: discountedPrice)
    }
    
    private func settingPrice(currency: String, price: UInt) {
        priceLabel.isHidden = true
        discountedPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: price)
    }
    
    // MARK: - setting stock UI
    private func settingSoldOut() {
        stockLabel.textColor = .systemYellow
        stockLabel.text = StockFormat.soldOut
    }
    
    private func settingStock(with stock: UInt) {
        stockLabel.textColor = .systemGray2
        stockLabel.text = String(format: StockFormat.quantity, stock)
    }
}
