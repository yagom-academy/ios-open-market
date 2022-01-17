//
//  ProductCollectionViewListCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/14.
//

import UIKit

class ProductCollectionViewListCell: UICollectionViewCell, ReuseIdentifying, CollectionViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productFixedPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  @IBOutlet weak var productBargainPriceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
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
}
