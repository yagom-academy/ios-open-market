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
    stackView.spacing = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private func configureListCell() {
    contentView.addSubview(totalStackView)
    totalStackView.addArrangedSubview(thumbnailImageView)
    totalStackView.addArrangedSubview(verticalStackView)
    totalStackView.addArrangedSubview(stockLabel)
    verticalStackView.addArrangedSubview(nameLabel)
    verticalStackView.addArrangedSubview(priceStackView)
    priceStackView.addArrangedSubview(bargainPriceLabel)
    priceStackView.addArrangedSubview(discountedPriceLabel)
    
    NSLayoutConstraint.activate([
      totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
      
      thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor,
                                                multiplier: 1.2),
      
      verticalStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                               multiplier: 0.5)
    ])
  }
  
  func setUpListCell(page: Page) {
    self.thumbnailImageView.load(urlString: page.thumbnail)
    self.nameLabel.text = page.name
    if page.discountedPrice == 0 {
      self.bargainPriceLabel.text = "\(page.currency)\(page.bargainPrice)"
      self.discountedPriceLabel.text = ""
    } else {
      bargainPriceLabel.textColor = .systemRed
      self.bargainPriceLabel.attributedText = "\(page.currency)\(page.bargainPrice)".strikeThrough()
      self.discountedPriceLabel.text = "\(page.currency)\(page.discountedPrice)"
    }
    
    self.stockLabel.text = "잔여수량:\(page.stock)"
  }
}

extension String {
  func strikeThrough() -> NSAttributedString {
    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
    return attributeString
  }
}

extension UIImageView {
  func load(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}
