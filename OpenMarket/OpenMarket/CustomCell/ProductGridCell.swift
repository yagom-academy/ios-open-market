//
//  ProductGridCell.swift
//  OpenMarket
//
//  Created by Seul Mac on 2022/01/13.
//

import UIKit

class ProductGridCell: UICollectionViewCell {

    @IBOutlet weak var gridThumbnailImage: UIImageView!
    @IBOutlet weak var gridNameLabel: UILabel!
    @IBOutlet weak var gridPriceLabel: UILabel!
    @IBOutlet weak var gridStockLabel: UILabel!
    
    static let identifier = "GridCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with product: ProductDetail) {
        setupImage(with: product)
        setupNameLabel(with: product)
        setupPriceLabel(with: product)
        setupStockLabel(with: product)
    }
    
    func setupImage(with product: ProductDetail) {
        guard let imageURL = URL(string: product.thumbnail),
            let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) else {
               print("잘못된 이미지 URL입니다.")
               return
           }
        gridThumbnailImage.image = image
    }
    
    func setupNameLabel(with product: ProductDetail) {
        gridNameLabel.text = product.name
    }
    
    func setupPriceLabel(with product: ProductDetail) {
        let currentPriceText = product.currency + StringSeparator.blank + String(product.price)
        if product.discountedPrice == 0 {
            gridPriceLabel.attributedText = NSAttributedString(string: currentPriceText)
        } else {
            let previousPrice = currentPriceText.strikeThrough()
            let bargainPriceText = StringSeparator.newLine + product.currency + StringSeparator.blank + String(product.bargainPrice)
            let bargainPrice = NSAttributedString(string: bargainPriceText)
            
            let priceLabelText = NSMutableAttributedString()
            priceLabelText.append(previousPrice)
            priceLabelText.append(bargainPrice)
            gridPriceLabel.attributedText = priceLabelText
        }
    }
    
    func setupStockLabel(with product: ProductDetail) {
        if product.stock == 0 {
            gridStockLabel.text = LabelString.outOfStock
            gridStockLabel.textColor = .systemOrange
        } else {
            gridStockLabel.text = LabelString.stockTitle + String(product.stock)
        }
    }

}
