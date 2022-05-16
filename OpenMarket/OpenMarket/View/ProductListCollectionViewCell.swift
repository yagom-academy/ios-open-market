//
//  ProductListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/16.
//

import UIKit

final class ProductListCollectionViewCell: UICollectionViewCell {
  private let containerStackView = UIStackView()
  private let informationStackView = UIStackView()
  private let priceStackView = UIStackView()
  private let quantityStackView = UIStackView()

  private let productImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemRed
    return label
  }()
  
  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    return label
  }()
  
  private let disclosureImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = .systemGray
    imageView.image = UIImage(systemName: "chevron.right")
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
