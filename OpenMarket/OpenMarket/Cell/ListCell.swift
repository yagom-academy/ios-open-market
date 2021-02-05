//
//  ListCell.swift
//  OpenMarket
//
//  Created by sole on 2021/02/04.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func prepareForReuse() {
        self.tag = 0
        thumbnailImageView.image = nil
        titleLabel.text = nil
        discountedPriceLabel.text = nil
        priceLabel.attributedText = nil
        stockLabel.text = nil
        stockLabel.textColor = nil
    }
    
    func setContents(with item: Item) {
        setThumbnailImage(item.thumbnails.first)
        titleLabel.text = item.title
        let price = "\(item.currency) \(item.price.convertedToStringWithComma() ?? "0")"
        if let discountedPrice = item.discountedPrice {
            priceLabel.attributedText = price.strikeThrough()
            discountedPriceLabel.text = "\(item.currency) \(discountedPrice.convertedToStringWithComma() ?? "0")"
        } else {
            priceLabel.attributedText = NSAttributedString(string: price)
        }
        setStockText(count: item.stock)
    }
    
    private func setStockText(count: Int) {
        if count == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
            return
        }
        stockLabel.text = "잔여수량 : \(count)"
    }
    
    private func setThumbnailImage(_ url: String?) {
        let tag = self.tag
        DispatchQueue.global().async {
            if let url = url,
               let thumbnailURL = URL(string: url),
               let data = try? Data(contentsOf: thumbnailURL) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if self.tag == tag {
                        self.thumbnailImageView.image = image
                    }
                }
            }
        }
    }
}
