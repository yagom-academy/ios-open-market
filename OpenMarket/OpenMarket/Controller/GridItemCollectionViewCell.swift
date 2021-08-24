//
//  GridItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/17.
//

import UIKit

class GridItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    private var urlString: String?
    
    func initialize(item: Page.Item, indexPath: IndexPath) {
        updateImage(item: item, indexPath: indexPath)
        configureLabels(item: item)
        configureCellBorder()
    }
    
    private func updateImage(item: Page.Item, indexPath: IndexPath) {
        let currentURLString = item.thumbnails[0]
        self.urlString = currentURLString
        
        ImageLoader.shared.loadImage(from: currentURLString) { imageData in
            if self.urlString == currentURLString {
                self.thumbnailImageView?.image = imageData
            }
        }
    }
    
    private func configureLabels(item: Page.Item) {
        self.titleLabel.text = item.title
        
        handlePriceLabel(item: item)
        handleStockLabel(item: item)
    }
    
    private func handlePriceLabel(item: Page.Item) {
        if let discountedPrice = item.discountedPrice {
            let discountAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red,
                .strikethroughStyle: true
            ]
            
            discountedPriceLabel.isHidden = false
            self.discountedPriceLabel.text = discountedPrice.description
            self.priceLabel.attributedText = NSAttributedString(string: item.price.description,
                                                                attributes: discountAttributes)
        } else {
            discountedPriceLabel.isHidden = true
            self.priceLabel.text = item.price.description
        }
    }
    
    private func handleStockLabel(item: Page.Item) {
        let outOfStock = "품절"
        
        if item.stock == .zero {
            self.stockLabel.text = outOfStock
            self.stockLabel.textColor = .orange
        } else {
            self.stockLabel.text = item.stock.description
        }
    }
    
    private func configureCellBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailImageView.image = nil
        self.priceLabel.attributedText = nil
        self.stockLabel.textColor = .lightGray
    }
}
