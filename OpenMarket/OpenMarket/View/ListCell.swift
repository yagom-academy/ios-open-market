//
//  ListCell.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class ListCell: UICollectionViewCell {
  static var identifier: String {
    return String(describing: self)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureListCell()
    self.contentView.layer.addBottomBorder()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private let thumbnailImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = .systemFont(ofSize: FontSize.body)
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    return label
  }()
  
  private let accessoryImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "chevron.right")
    imageView.tintColor = .lightGray
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: FontSize.body)
    label.textColor = .systemGray
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    return label
  }()
  
  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: FontSize.body)
    return label
  }()
  
  private let nameStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .top
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  private let priceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .top
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  private let verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    return stackView
  }()
  
  private let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
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
    self.priceLabel.text = nil
    self.priceLabel.attributedText = nil
    self.priceLabel.isHidden = false
  }
  
  private func configureListCell() {
    contentView.addSubview(totalStackView)
    totalStackView.axis = .horizontal
    totalStackView.addArrangedSubviews(thumbnailImageView, verticalStackView)
    verticalStackView.addArrangedSubviews(nameStackView, priceStackView)
    nameStackView.addArrangedSubviews(nameLabel, stockLabel, accessoryImageView)
    priceStackView.addArrangedSubviews(priceLabel, bargainPriceLabel)
    
    NSLayoutConstraint.activate([
      totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
      totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor,
                                                multiplier: 1.1),
      accessoryImageView.widthAnchor.constraint(equalTo: accessoryImageView.heightAnchor,
                                                multiplier: 0.75)
    ])
  }
  
  func setUpListCell(page: Page) {
    self.thumbnailImageView.load(urlString: page.thumbnail)
    self.nameLabel.text = page.name
    
    if page.discountedPrice == 0 {
      self.priceLabel.isHidden = true
      self.bargainPriceLabel.text = "\(page.currency)\(page.bargainPrice.formatToDecimal())"
      self.bargainPriceLabel.textColor = .systemGray
    } else {
      self.priceLabel.textColor = .systemRed
      self.priceLabel.attributedText = "\(page.currency)\(page.price.formatToDecimal())".strikeThrough()
      self.bargainPriceLabel.text = "\(page.currency)\(page.bargainPrice.formatToDecimal())"
      self.bargainPriceLabel.textColor = .systemGray
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

