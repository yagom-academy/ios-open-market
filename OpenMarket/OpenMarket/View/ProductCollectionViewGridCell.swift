//
//  ProductCollectionViewGridCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

class ProductCollectionViewGridCell: UICollectionViewCell, ReuseIdentifying, ProductCollectionViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productBargainPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  @IBOutlet weak var productFixedPriceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureBorderStyle()
  }
  
  private func configureBorderStyle() {
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.gray.cgColor
    contentView.layer.cornerRadius = 8
  }
}
