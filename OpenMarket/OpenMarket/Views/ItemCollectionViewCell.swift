//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by YongHoon JJo on 2021/08/16.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemThumbnailImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountedPriceLabel: UILabel!
    @IBOutlet weak var itemStockLabel: UILabel!

    func configureLabels(on marketItem: MarketPageItem) {
        itemTitleLabel.text = marketItem.title
        itemPriceLabel.text = "\(marketItem.price)"
        if let discountedPrice = marketItem.discountedPrice {
            itemDiscountedPriceLabel.text = "\(discountedPrice)"
        } else {
            itemDiscountedPriceLabel.text = nil
        }
        itemStockLabel.text = marketItem.stock == .zero ? "품절" : "잔여수량 : \(marketItem.stock)"
    }
}
