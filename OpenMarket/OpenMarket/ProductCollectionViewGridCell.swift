//
//  ProductCollectionViewGridCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

class ProductCollectionViewGridCell: UICollectionViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.cornerRadius = 8
  }
  
  func insertCellData(image: UIImage, name: String, price: String, bargainPrice: String , stock: String) {
    productImageView.image = image
    productNameLabel.text = name
    productPriceLabel.text = price
    productPriceLabel.attributedText = price.strikeThrough(strikeTaget: bargainPrice)
    productStockLabel.text = stock
  }
}
