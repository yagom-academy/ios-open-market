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
        settingPrice(with: goods.currency, price: goods.price, discountedPrice: goods.discountedPrice)
        
        if goods.stock == 0 {
            goodsStockLabel.textColor = .systemYellow
            goodsStockLabel.text = "품절"
        } else {
            goodsStockLabel.textColor = .systemGray2
            goodsStockLabel.text = "\(goods.stock)"
        }
    }
    
    private func settingPrice(with currency: String, price: UInt, discountedPrice: UInt?) {
        if let discountedPrice = discountedPrice {
            goodsOriginalPriceLabel.isHidden = false
            goodsOriginalPriceLabel.attributedText = PriceFormat.makePriceStringWithStrike(currency: currency, price: discountedPrice)
            goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: discountedPrice)
        } else {
            goodsOriginalPriceLabel.isHidden = true
            goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: price)
        }
    }
}
