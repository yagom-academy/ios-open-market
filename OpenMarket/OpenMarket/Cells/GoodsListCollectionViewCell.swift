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
        if let finalPrice = goods.discountedPrice {
            goodsOriginalPriceLabel.isHidden = false
            goodsOriginalPriceLabel.text = PriceFormat.makePriceString(currency: goods.currency, price: goods.price)
            goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: goods.currency, price: finalPrice)
        } else {
            goodsOriginalPriceLabel.isHidden = true
            goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: goods.currency, price: goods.price)
        }
        if goods.stock == 0 {
            goodsStockLabel.textColor = .systemYellow
            goodsStockLabel.text = "품절"
        } else {
            goodsStockLabel.textColor = .systemGray2
            goodsStockLabel.text = "\(goods.stock)"
        }
    }
}
