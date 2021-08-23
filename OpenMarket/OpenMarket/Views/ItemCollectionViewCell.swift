//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/16.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var itemThumbnailImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    @IBOutlet private weak var itemPriceLabel: UILabel!
    @IBOutlet private weak var itemDiscountedPriceLabel: UILabel!
    @IBOutlet private weak var itemStockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initCellDesign()
    }
    
    private func initCellDesign() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 8
    }

    func configure(with marketItem: MarketPageItem) {
        updateThumbnailImage(to: marketItem)
        updateLabels(to: marketItem)
    }
    
    private func updateLabels(to marketItem: MarketPageItem) {
        updateTitleLabels(to: marketItem)
        updatePriceLabels(to: marketItem)
        updateDiscountedPriceLabels(to: marketItem)
        updateStockLabels(to: marketItem)
    }
    
    private func updateTitleLabels(to marketItem: MarketPageItem) {
        itemTitleLabel.text = marketItem.title
    }
    
    private func getFormattedNumber(of number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) else {
            return nil
        }
        return formattedNumber
    }
    
    private func updatePriceLabels(to marketItem: MarketPageItem) {
        guard let text = itemPriceLabel.text,
              let price = getFormattedNumber(of: marketItem.price) else {
            return
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        if marketItem.discountedPrice != nil {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
            itemPriceLabel.attributedText = attributedString
            itemPriceLabel.textColor = .red
        } else {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: range)
            itemPriceLabel.attributedText = attributedString
            itemPriceLabel.textColor = .lightGray
        }
        itemPriceLabel.text = "\(marketItem.currency) \(price)"
    }
    
    private func updateDiscountedPriceLabels(to marketItem: MarketPageItem) {
        if let discountedPrice = marketItem.discountedPrice,
           let formattedDiscountedPrice = getFormattedNumber(of: discountedPrice) {
            itemDiscountedPriceLabel.text = "\(marketItem.currency) \(formattedDiscountedPrice)"
            itemDiscountedPriceLabel.textColor = .lightGray
        } else {
            itemDiscountedPriceLabel.text = nil
        }
    }
    
    private func updateStockLabels(to marketItem: MarketPageItem) {
        guard let stock = getFormattedNumber(of: marketItem.stock) else {
            return
        }
        
        if marketItem.stock == .zero {
            itemStockLabel.text = "품절"
            itemStockLabel.textColor = .orange
        } else {
            let enoughCount = 9999
            let leftover = marketItem.stock > enoughCount ? "충분함" : stock
            itemStockLabel.text = "잔여수량 : \(leftover)"
            itemStockLabel.textColor = .lightGray
        }
    }
    
    private func updateThumbnailImage(to marketItem: MarketPageItem) {
        for thumbnail in marketItem.thumbnails {
            if let data = ImageManager.shared.loadImageData(imageUrl: thumbnail) {
                itemThumbnailImageView.image = UIImage(data: data)
                return
            }
            if let url = URL(string: thumbnail),
               let data = try? Data(contentsOf: url) {
                itemThumbnailImageView.image = UIImage(data: data)
                ImageManager.shared.cacheImagData(imageUrl: thumbnail, data: data)
                return
            }
        }
        
        if let data = ImageManager.shared.loadImageData(imageUrl: ImageManager.shared.noImageDataUrl) {
            itemThumbnailImageView.image = UIImage(data: data)
            return
        }
    }
}
