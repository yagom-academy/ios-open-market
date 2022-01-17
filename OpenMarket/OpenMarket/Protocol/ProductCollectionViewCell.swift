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
