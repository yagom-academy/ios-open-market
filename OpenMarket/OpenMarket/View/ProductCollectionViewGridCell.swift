//
//  ProductCollectionViewGridCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

class ProductCollectionViewGridCell: UICollectionViewCell, ReuseIdentifying, CollectionViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productBargainPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  @IBOutlet weak var productFixedPriceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureBorderStyle()
  }
  
  func setCellImage(image: UIImage?) {
    productImageView.image = image
  }
  
  func setCellData(product: Product) {
    productNameLabel.text = product.name
    productFixedPriceLabel.attributedText = product.formattedFixedPrice.strikeThrough(strikeTarget: product.formattedFixedPrice)
    productBargainPriceLabel.text = product.formattedBargainPrice
    if product.formattedFixedPrice == product.formattedBargainPrice {
      productFixedPriceLabel.isHidden = true
    }
    if product.formattedStock == "품절" {
      productStockLabel.textColor = .orange
    } else {
      productStockLabel.textColor = .darkGray
    }
    productStockLabel.text = product.formattedStock
  }
  
  private func configureBorderStyle() {
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.cornerRadius = 8
  }
}
