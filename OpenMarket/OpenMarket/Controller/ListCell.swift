//
//  ListCell.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class ListCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureListCell()
    self.contentView.layer.addBottomBorder()
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
    label.font = .systemFont(ofSize: 17, weight: .bold)
    return label
  }()
  
  let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 17)
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
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.thumbnailImageView.image = UIImage(systemName: "goforward")
    self.nameLabel.text = nil
    self.stockLabel.text = nil
    self.bargainPriceLabel.text = nil
    self.discountedPriceLabel.text = nil
  }
  
  private func configureListCell() {
    contentView.addSubview(totalStackView)
    totalStackView.axis = .horizontal
    totalStackView.addArrangedSubviews(thumbnailImageView, verticalStackView, stockLabel)
    verticalStackView.addArrangedSubviews(nameLabel, priceStackView)
    priceStackView.addArrangedSubviews(bargainPriceLabel, discountedPriceLabel)
    
    NSLayoutConstraint.activate([
      totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor,
                                                multiplier: 1.1),
      
      verticalStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                               multiplier: 0.4)
    ])
  }
  
  func setUpListCell(page: Page) {
    self.thumbnailImageView.load(urlString: page.thumbnail)
    self.nameLabel.text = page.name
    let bargainPrice = page.currency + page.bargainPrice.convertCurrency()
    
    if page.discountedPrice == 0 {
      self.bargainPriceLabel.textColor = .systemGray
      self.bargainPriceLabel.attributedText = .none
      self.bargainPriceLabel.text = bargainPrice
      self.discountedPriceLabel.isHidden = true
    } else {
      self.bargainPriceLabel.textColor = .systemRed
      self.bargainPriceLabel.attributedText = bargainPrice.strikeThrough()
      self.discountedPriceLabel.isHidden = false
      self.discountedPriceLabel.text = page.currency + page.discountedPrice.convertCurrency()
    }
    
    if page.stock == 0 {
      self.stockLabel.textColor = .systemYellow
      self.stockLabel.text = "품절"
    } else {
      self.stockLabel.textColor = .systemGray
      self.stockLabel.text = "잔여수량 : \(page.stock)" 
    }
  }
}

