//
//  GridItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/17.
//

import UIKit

class GridItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    
    private var urlString: String?
    
    func initialize(item: Page.Item, indexPath: IndexPath) {
        updateImage(item: item, indexPath: indexPath)
        configureLabels(item: item)
        configureCellBorder()
    }
    
    private func updateImage(item: Page.Item, indexPath: IndexPath) {
        let currentURLString = item.thumbnails[0]
        urlString = currentURLString
        thumbnailImageView.image = UIImage(systemName: "photo")
        
        ImageLoader.shared.loadImage(from: currentURLString) { imageData in
            if self.urlString == currentURLString {
                self.thumbnailImageView?.image = imageData
            }
        }
    }
    
    private func configureLabels(item: Page.Item) {
        titleLabel.text = item.title
        
        handlePriceLabel(item: item)
        handleStockLabel(item: item)
    }
    
    private func handlePriceLabel(item: Page.Item) {
        let priceWithCurrency = combine(price: format(item.price), currency: item.currency)
        
        if let discountedPrice = item.discountedPrice {
            let discountAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red,
                .strikethroughStyle: true
            ]
            
            discountedPriceLabel.isHidden = false
            discountedPriceLabel.text = combine(price: format(discountedPrice),
                                                     currency: item.currency)
            priceLabel.attributedText = NSAttributedString(string: priceWithCurrency,
                                                                attributes: discountAttributes)
        } else {
            discountedPriceLabel.isHidden = true
            priceLabel.text = priceWithCurrency
        }
    }
    
    private func handleStockLabel(item: Page.Item) {
        let outOfStock = "품절"
        let residualQuantity = "잔여수량 : "
        
        if item.stock == .zero {
            stockLabel.text = outOfStock
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = residualQuantity + item.stock.description
        }
    }
    
    private func combine(price: String, currency: String) -> String {
        return currency + " " + price
    }
    
    private func format(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        if let formattedNumber = numberFormatter.string(from: number as NSNumber) {
            return formattedNumber
        }
        return number.description
    }
    
    private func configureCellBorder() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        priceLabel.attributedText = nil
        stockLabel.textColor = .lightGray
    }
}
