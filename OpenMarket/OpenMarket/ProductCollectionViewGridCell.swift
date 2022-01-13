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
  @IBOutlet weak var productBargainLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  @IBOutlet weak var productFixedPrice: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.cornerRadius = 8
  }
  
  func insertCellData(image: UIImage, name: String, fixedPrice: String, bargainPrice: String , stock: String) {
    productImageView.image = image
    productNameLabel.text = name
    productFixedPrice.attributedText = fixedPrice.strikeThrough(strikeTaget: fixedPrice)
    if fixedPrice == bargainPrice {
      productFixedPrice.isHidden = true
    }
    productBargainLabel.text = bargainPrice
    productStockLabel.text = stock
  }
}
