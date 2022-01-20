//
//  ProductCollectionViewListCell.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/14.
//

import UIKit

class ProductCollectionViewListCell: UICollectionViewCell, ReuseIdentifying, ProductCollectionViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productFixedPriceLabel: UILabel!
  @IBOutlet weak var productStockLabel: UILabel!
  @IBOutlet weak var productBargainPriceLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
