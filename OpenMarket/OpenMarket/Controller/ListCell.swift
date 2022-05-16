//
//  ListCell.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class ListCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureListCell()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  let thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }()
  
  let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 17)
    label.textColor = .systemGray
    return label
  }()
  
  let discountedPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 17)
    label.textColor = .systemGray
    return label
  }()
  
  let stockLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = .systemFont(ofSize: 17)
    label.textColor = .systemGray
    return label
  }()
  
  let priceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .bottom
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  let verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .top
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  func configureListCell() {
    contentView.addSubview(totalStackView)
    totalStackView.addArrangedSubview(thumbnailImageView)
    totalStackView.addArrangedSubview(verticalStackView)
    totalStackView.addArrangedSubview(stockLabel)
    verticalStackView.addArrangedSubview(nameLabel)
    verticalStackView.addArrangedSubview(priceStackView)
    priceStackView.addArrangedSubview(bargainPriceLabel)
    priceStackView.addArrangedSubview(discountedPriceLabel)
    
    NSLayoutConstraint.activate([
      totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
