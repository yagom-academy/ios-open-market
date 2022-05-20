//   GridCell.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class GridCell: UICollectionViewCell {
  static var identifier: String {
    return String(describing: self)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureGridCell()
    self.contentView.layer.borderWidth = 1.5
    self.contentView.layer.borderColor = UIColor.lightGray.cgColor
    self.contentView.layer.cornerRadius = 10
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
    label.textAlignment = .center
    label.font = .systemFont(ofSize: FontSize.title, weight: .bold)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: FontSize.body)
    label.textColor = .systemGray
    return label
  }()
  
  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: FontSize.body)
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: FontSize.body)
    return label
  }()
  
  private let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let priceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    return stackView
  }()
  
  private let infoStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
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
  
  private func configureGridCell() {
    contentView.addSubview(totalStackView)
    totalStackView.axis = .vertical
    totalStackView.addArrangedSubviews(thumbnailImageView,
                                       infoStackView)
    infoStackView.addArrangedSubviews(nameLabel, priceStackView, stockLabel)
    priceStackView.addArrangedSubviews(priceLabel, bargainPriceLabel)
    
    NSLayoutConstraint.activate([
      totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor,
                                                multiplier: 1.1),
      thumbnailImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor,
                                                 multiplier: 0.5)
    ])
  }
  
  func setUpGridCell(page: Page) {
    self.thumbnailImageView.loadImage(urlString: page.thumbnail)
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
