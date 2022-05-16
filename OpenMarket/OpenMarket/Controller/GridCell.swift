//
//  GridCell.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class GridCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureGridCell()
    self.contentView.layer.borderWidth = 1
    self.contentView.layer.borderColor = UIColor.gray.cgColor
    self.contentView.layer.cornerRadius = 10
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
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }()
  
  let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 17)
    label.textColor = .systemGray
    return label
  }()
  
  let discountedPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 17)
    label.textColor = .systemGray
    return label
  }()
  
  let stockLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 17)
    label.textColor = .systemGray
    return label
  }()
  
  let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private func configureGridCell() {
    contentView.addSubview(totalStackView)
    totalStackView.axis = .vertical
    totalStackView.addArrangedSubview(thumbnailImageView)
    totalStackView.addArrangedSubview(nameLabel)
    totalStackView.addArrangedSubview(bargainPriceLabel)
    totalStackView.addArrangedSubview(discountedPriceLabel)
    totalStackView.addArrangedSubview(stockLabel)
    
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
  
  func setUpListCell(page: Page) {
    self.thumbnailImageView.load(urlString: page.thumbnail)
    self.nameLabel.text = page.name
    if page.discountedPrice == 0 {
      self.bargainPriceLabel.textColor = .systemGray
      self.bargainPriceLabel.attributedText = .none
      self.bargainPriceLabel.text = "\(page.currency)\(page.bargainPrice)"
      self.discountedPriceLabel.text = ""
    } else {
      self.bargainPriceLabel.textColor = .systemRed
      self.bargainPriceLabel.attributedText = "\(page.currency)\(page.bargainPrice)".strikeThrough()
      self.discountedPriceLabel.text = "\(page.currency)\(page.discountedPrice)"
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
