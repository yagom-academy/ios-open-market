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
        updateContents(item: item, indexPath: indexPath)
        configureStyle(item: item)
    }
    
    private func updateContents(item: Page.Item, indexPath: IndexPath) {
        self.titleLabel.text = item.title
        self.priceLabel.text = item.price.description
        self.stockLabel.text = item.stock.description
        
        handleDiscountedPrice(item: item, indexPath: indexPath)
        let currentURLString = item.thumbnails[0]
        self.urlString = currentURLString
        
        ImageLoader.shared.loadImage(from: currentURLString) { imageData in
            if self.urlString == currentURLString {
                self.thumbnailImageView?.image = imageData
            }
        }
    }
    
    private func configureStyle(item: Page.Item) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
        
        let outOfStock = "품절"
        
        if item.stock == .zero {
            self.stockLabel.text = outOfStock
            self.stockLabel.textColor = .orange
        }
        
        let discountAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .strikethroughStyle: true
        ]
        
        if item.discountedPrice != nil {
            self.priceLabel.attributedText = NSAttributedString(string: item.price.description,
                                                                attributes: discountAttributes)
        }
    }
    
    private func handleDiscountedPrice(item: Page.Item, indexPath: IndexPath) {
        if let discountedPrice = item.discountedPrice {
            discountedPriceLabel.isHidden = false
            self.discountedPriceLabel.text = discountedPrice.description
        } else {
            discountedPriceLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailImageView.image = nil
        self.priceLabel.attributedText = nil
        self.stockLabel.textColor = .lightGray
    }
}
