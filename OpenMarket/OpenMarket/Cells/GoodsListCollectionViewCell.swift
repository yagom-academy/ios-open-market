//
//  GoodsListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/03.
//

import UIKit

class GoodsListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var goodsOriginalPriceLabel: UILabel!
    @IBOutlet weak var goodsFinalPriceLabel: UILabel!
    @IBOutlet weak var goodsStockLabel: UILabel!
    
    override func prepareForReuse() {
        goodsImageView.image = nil
    }
    
    func settingWithGoods(_ goods: Goods) {
        goodsNameLabel.text = goods.title
        settingThumbnailImage(with: goods.thumbnails)
        if let discountedPrice = goods.discountedPrice {
            settingPriceWithDiscount(with: goods.currency, price: goods.price, discountedPrice: discountedPrice)
        } else {
            settingPrice(with: goods.currency, price: goods.price)
        }
        if goods.stock == 0 {
            settingSoldOut()
        } else {
            settingStock(with: goods.stock)
        }
    }
    
    // MARK: - setting thumbnail
    private func settingThumbnailImage(with thumbnails: [String]) {
        
    }
    
    // MARK: - setting Price UI
    private func settingPriceWithDiscount(with currency: String, price: UInt, discountedPrice: UInt) {
        goodsOriginalPriceLabel.isHidden = false
        goodsOriginalPriceLabel.attributedText = PriceFormat.makePriceStringWithStrike(currency: currency, price: discountedPrice)
        goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: discountedPrice)
    }
    
    private func settingPrice(with currency: String, price: UInt) {
        goodsOriginalPriceLabel.isHidden = true
        goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: price)
    }
    
    // MARK: - setting stock UI
    private func settingSoldOut() {
        goodsStockLabel.textColor = .systemYellow
        goodsStockLabel.text = StockFormat.soldOut
    }
    
    private func settingStock(with stock: UInt) {
        goodsStockLabel.textColor = .systemGray2
        goodsStockLabel.text = String(format: StockFormat.quantity, stock)
    }
}
