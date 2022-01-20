//
//  ProductCollectionViewCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/17.
//

import UIKit

protocol ProductCollectionViewCell: UICollectionViewCell {
  var productImageView: UIImageView! { get set }
  var productNameLabel: UILabel! { get set }
  var productBargainPriceLabel: UILabel! { get set }
  var productStockLabel: UILabel! { get set }
  var productFixedPriceLabel: UILabel! { get set }
  
  func setCellImage(image: UIImage?)
  func setCellData(product: Product)
}

extension ProductCollectionViewCell {
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
