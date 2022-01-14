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
  @IBOutlet weak var productBargainPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  @IBOutlet weak var productFixedPriceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.cornerRadius = 8
  }
  
  func insertCellData(image: UIImage, name: String, fixedPrice: String, bargainPrice: String , stock: String) {
    productImageView.image = image
    productNameLabel.text = name
    productFixedPriceLabel.attributedText = fixedPrice.strikeThrough(strikeTarget: fixedPrice)
    if fixedPrice == bargainPrice {
      productFixedPriceLabel.isHidden = true
    }
    if stock == "품절" {
      productStockLabel.textColor = .orange
    } else {
      productStockLabel.textColor = .darkGray
    }
    productBargainPriceLabel.text = bargainPrice
    productStockLabel.text = stock
  }
}
