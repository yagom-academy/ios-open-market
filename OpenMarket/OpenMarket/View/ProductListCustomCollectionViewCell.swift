//
//  ProductListCustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/24.
//

import UIKit

class ProductListCustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    
    static let identifier = "ProductListCustomCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func layoutSubviews() {
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func prepareForReuse() {
        thumbnailImage.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        discountedPriceLabel.text = nil
        stockLabel.text = nil
    }
    
    private func loadThumbnails(product: Product) {
        if let thumbnail = product.thumbnails.first,
           let thumbnailURL = URL(string: thumbnail),
           let data = try? Data(contentsOf: thumbnailURL) {
            DispatchQueue.main.async { [self] in
                thumbnailImage.image = UIImage(data: data)
            }
        }
    }
    
    func configure(_ product: Product) {
        loadThumbnails(product: product)
        updateLabels(product: product)
    }
    
    private func updateLabels(product: Product) {
        updateTitle(product: product)
        updateOriginPrice(product: product)
        updateDiscountedPrice(product: product)
        updataeStock(product: product)
    }
    
    private func updateTitle(product: Product) {
        titleLabel.text = product.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    private func updateOriginPrice(product: Product) {
        priceLabel.text = "\(product.currency)\(product.price)"
        guard let text = priceLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        if product.discountedPrice != nil {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
            priceLabel.attributedText = attributedString
            priceLabel.textColor = .red
        } else {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: range)
            priceLabel.attributedText = attributedString
            priceLabel.textColor = .lightGray
        }
    }
    
    private func updateDiscountedPrice(product: Product) {
        if let discountedPrice = product.discountedPrice {
            discountedPriceLabel.text = "\(product.currency)\(discountedPrice)"
            discountedPriceLabel.textColor = .lightGray
        } else {
            discountedPriceLabel.text = ""
        }
    }
    
    private func updataeStock(product: Product) {
        if product.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            let enoughCount = 9999
            let leftover = product.stock > enoughCount ? "재고 많음" : "\(product.stock)"
            stockLabel.text = "잔여수량 : \(leftover)"
            stockLabel.textColor = .lightGray
        }
    }
}
