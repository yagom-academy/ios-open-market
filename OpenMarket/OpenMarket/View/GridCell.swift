//
//  GridCell.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/11.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBorder()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        discountedPriceLabel.isHidden = false
        priceLabel.attributedText = nil
    }
    
    func configure(with product: Product) {
        
        setImageView(with: product.thumbnailURL)
        setProductNameLabel(to: product.name)
        setPriceLabels(with: product.price, and: product.discountedPrice, currency: product.currency)
        setStockLabel(to: product.stock)
    }
}

extension GridCell {
    private func setBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
    }
    
    private func setImageView(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        imageView.image = UIImage(data: data)
    }
    
    private func setProductNameLabel(to productName: String) {
        productNameLabel.text = productName
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private func setPriceLabels(with price: Int, and discountedPrice: Int, currency: String) {
        let dontShowDiscounted = discountedPrice == 0
        guard let priceString = price.decimalFormat,
              let discountedPriceString = discountedPrice.decimalFormat else {
                  return
              }
        priceLabel.text = currency + " " + priceString
        discountedPriceLabel.text = currency + " " + discountedPriceString
        
        if dontShowDiscounted {
            discountedPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray
        } else {
            guard let priceLabelString = priceLabel.text else {
                return
            }
            let attributeString = NSMutableAttributedString(string: priceLabelString)
            
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            priceLabel.attributedText = attributeString
            priceLabel.textColor = .red
            discountedPriceLabel.textColor = .systemGray
        }
    }
    
    private func setStockLabel(to stock: Int) {
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        } else {
            stockLabel.text = "잔여수량: " + stock.stringFormat
            stockLabel.textColor = .systemGray
        }
    }
}
