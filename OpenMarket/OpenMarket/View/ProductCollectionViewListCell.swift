//
//  ProductCollectionViewListCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/14.
//

import UIKit

class ProductCollectionViewListCell: UICollectionViewCell{
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productFixedPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  @IBOutlet weak var productBargainPriceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func insertCellData(image: UIImage, name: String, fixedPrice: String, bargainPrice: String , stock: String) {
    productImageView.image = image
    productNameLabel.text = name
    
    productFixedPriceLabel.attributedText = fixedPrice.strikeThrough(strikeTarget: fixedPrice)
    productBargainPriceLabel.text = bargainPrice
    if fixedPrice == bargainPrice {
      productFixedPriceLabel.isHidden = true
    }
    
    if stock == "품절" {
      productStockLabel.textColor = .orange
    } else {
      productStockLabel.textColor = .darkGray
    }
    productStockLabel.text = stock
  }
}
