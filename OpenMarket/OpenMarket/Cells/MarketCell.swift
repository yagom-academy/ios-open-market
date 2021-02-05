//
//  MarketCell.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/05.
//

import UIKit

class MarketCell: UICollectionViewCell {
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var goodsOriginalPriceLabel: UILabel!
    @IBOutlet weak var goodsFinalPriceLabel: UILabel!
    @IBOutlet weak var goodsStockLabel: UILabel!
    
    override func prepareForReuse() {
        goodsImageView.image = nil
        goodsNameLabel.text = nil
        goodsOriginalPriceLabel.text = nil
        goodsFinalPriceLabel.text = nil
        goodsStockLabel.text = nil
    }
    
    //MARK: - Configure Cell with Goods
    func configure(_ goods: Goods, isLast: Bool) {
        goodsNameLabel.text = goods.title
        if let firstThumbnail = goods.thumbnails.first {
            setGoodsThumbnail(with: firstThumbnail)
        }
        if let discountedPrice = goods.discountedPrice {
            setGoodsDiscountPriceLabel(with: goods.currency, price: goods.price, discountedPrice: discountedPrice)
        } else {
            setGoodsPriceLabel(with: goods.currency, price: goods.price)
        }
        if goods.stock == 0 {
            setSoldOutLabel()
        } else {
            setStockLabel(with: goods.stock)
        }
    }
    
    // MARK: - setting Thumbnail UI
    private func setGoodsThumbnail(with urlString: String) {
        goodsImageView.setWebImage(urlString: urlString)
    }
    
    // MARK: - setting Price UI
    private func setGoodsDiscountPriceLabel(with currency: String, price: UInt, discountedPrice: UInt) {
        goodsOriginalPriceLabel.isHidden = false
        goodsOriginalPriceLabel.attributedText = PriceFormat.makePriceStringWithStrike(currency: currency, price: discountedPrice)
        goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: discountedPrice)
    }
    
    private func setGoodsPriceLabel(with currency: String, price: UInt) {
        goodsOriginalPriceLabel.isHidden = true
        goodsFinalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: price)
    }
    
    // MARK: - setting stock UI
    private func setSoldOutLabel() {
        goodsStockLabel.textColor = .systemYellow
        goodsStockLabel.text = StockFormat.soldOut
    }
    
    private func setStockLabel(with stock: UInt) {
        goodsStockLabel.textColor = .systemGray2
        goodsStockLabel.text = String(format: StockFormat.quantity, stock)
    }
}
