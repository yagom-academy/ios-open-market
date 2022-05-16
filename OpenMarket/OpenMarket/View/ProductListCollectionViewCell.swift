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
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
  
  private func configureUI() {
    self.contentView.addSubview(containerStackView)
    self.containerStackView.addArrangedSubview(productImageView)
    self.containerStackView.addArrangedSubview(informationStackView)
    self.containerStackView.addArrangedSubview(quantityStackView)
    
    self.informationStackView.addArrangedSubview(titleLabel)
    self.informationStackView.addArrangedSubview(priceStackView)
    self.priceStackView.addArrangedSubview(bargainPriceLabel)
    self.priceStackView.addArrangedSubview(priceLabel)
    
    self.quantityStackView.addArrangedSubview(stockLabel)
    self.quantityStackView.addArrangedSubview(disclosureImageView)
    
    self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
