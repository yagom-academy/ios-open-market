//
//  GoodsGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김호준 on 2021/02/03.
//

import UIKit

class GoodsGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
        productTitleLabel.text = nil
        originalPriceLabel.text = nil
        finalPriceLabel.text = nil
        stockLabel.text = nil
    }
    
    //MARK: - Configure Cell with Goods
    public func configure(goods: Goods) {
        setupCellView()
        productTitleLabel.text = goods.title
        if let thumbnails = goods.thumbnails.first {
            thumbnailImageView.setImageWithURL(urlString: thumbnails)
        }
        if let discountedPrice = goods.discountedPrice {
            setGoodsDiscountPriceLabel(currency: goods.currency,
                                     price: goods.price,
                                     discountedPrice: discountedPrice)
        } else {
            setGoodsPriceLabel(currency: goods.currency, price: goods.price)
        }
        
        if goods.stock == 0 {
            setSoldOutLabel()
        } else {
            setStockLabel(with: goods.stock)
        }
    }
    
    // MARK: - setting Price UI
    private func setGoodsDiscountPriceLabel(currency: String, price: UInt, discountedPrice: UInt) {
        originalPriceLabel.isHidden = false
        originalPriceLabel.attributedText = PriceFormat.makePriceStringWithStrike(currency: currency, price: discountedPrice)
        finalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: discountedPrice)
    }
    
    private func setGoodsPriceLabel(currency: String, price: UInt) {
        originalPriceLabel.isHidden = true
        finalPriceLabel.text = PriceFormat.makePriceString(currency: currency, price: price)
    }
    
    // MARK: - setting stock UI
    private func setSoldOutLabel() {
        stockLabel.textColor = .systemYellow
        stockLabel.text = StockFormat.soldOut
    }
    
    private func setStockLabel(with stock: UInt) {
        stockLabel.textColor = .systemGray2
        stockLabel.text = String(format: StockFormat.quantity, stock)
    }
    
    //MARK: - setting entire cell's view
    private func setupCellView() {
        cellView.layer.borderWidth = 2.0
        cellView.layer.cornerRadius = 8
        cellView.layer.masksToBounds = false
        cellView.layer.borderColor = UIColor.systemGray2.cgColor
    }
}
