//
//  ListCell.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/11.
//

import UIKit

final class ListCell: UICollectionViewCell {
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    //MARK: - Configure Methods
    
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

//MARK: - Private Methods

extension ListCell {
    private func setImageView(with urlString: String) {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url)else {
                  return
              }
        imageView.image = UIImage(data: data)
    }
    
    private func setProductNameLabel(to productName: String) {
        productNameLabel.text = productName
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private func setPriceLabels(with price: Int, and discountedPrice: Int, currency: String) {
        let isNotDiscounted = discountedPrice == 0
        guard let priceString = price.decimalFormat,
              let discountedPriceString = discountedPrice.decimalFormat else {
            return
        }
        priceLabel.text = currency + CellString.space + priceString
        discountedPriceLabel.text = currency + CellString.space + discountedPriceString
        
        if isNotDiscounted {
            discountedPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray
        } else {
            priceLabel.attributedText = convertToAttributedString(from: priceLabel)
            priceLabel.textColor = .red
            discountedPriceLabel.textColor = .systemGray
        }
    }
    
    private func setStockLabel(to stock: Int) {
        if stock == 0 {
            stockLabel.text = CellString.outOfStock
            stockLabel.textColor = .systemOrange
        } else {
            stockLabel.text = CellString.remainingStock + stock.stringFormat
            stockLabel.textColor = .systemGray
        }
    }
    
    private func convertToAttributedString(from label: UILabel) -> NSMutableAttributedString? {
        guard let priceLabelString = label.text else {
            return nil
        }
        let attributeString = NSMutableAttributedString(string: priceLabelString)
        let range = NSRange(location: 0, length: attributeString.length)
        attributeString.addAttribute(.strikethroughStyle, value: 1, range: range)
        
        return attributeString
    }
}
