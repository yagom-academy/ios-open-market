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

    func configure(with marketItem: MarketPageItem) {
        updateThumbnailImage(to: marketItem)
        updateLabels(to: marketItem)
    }
    
    private func updateLabels(to marketItem: MarketPageItem) {
        itemTitleLabel.text = marketItem.title
        itemPriceLabel.text = "\(marketItem.currency) \(marketItem.price)"
        if let discountedPrice = marketItem.discountedPrice {
            itemDiscountedPriceLabel.text = "\(marketItem.currency) \(discountedPrice)"
        } else {
            itemDiscountedPriceLabel.text = nil
        }
        itemStockLabel.text = marketItem.stock == .zero ? "품절" : "잔여수량 : \(marketItem.stock)"
    }
    
    private func updateThumbnailImage(to marketItem: MarketPageItem) {
        for thumbnail in marketItem.thumbnails {
            if let url = URL(string: thumbnail),
                  let data = try? Data(contentsOf: url) {
                itemThumbnailImageView.image = UIImage(data: data)
                return
            }
        }
    }
}
