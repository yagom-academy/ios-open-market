//
//  ProductGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/17.
//

import UIKit

final class ProductGridCollectionViewCell: UICollectionViewCell {
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    return stackView
  }()
  
  private let informationStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 20.0
    return stackView
  }()
  
  private let priceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()
  
  private let productImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemRed
    label.textAlignment = .center
    return label
  }()
  
  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.textAlignment = .center
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }
  
  func setUp(product: Product) {
    self.setPriceLabel(product)
    self.setStockLabel(product)
    self.titleLabel.text = product.name
    self.priceLabel.setStrike(text: "\(product.currency.rawValue) \(product.price.toDecimal)")
    self.bargainPriceLabel.text = "\(product.currency.rawValue) \(product.bargainPrice.toDecimal)"
    self.productImageView.image = UIImage(data: convertImageFromData(url: product.thumbnail))
  }

  private func convertImageFromData(url urlString: String) -> Data {
    guard let url = URL(string: urlString),
          let data = try? Data(contentsOf: url)
    else { return Data() }
    return data
  }
}

// MARK: - UI

private extension ProductGridCollectionViewCell {
  func setPriceLabel(_ product: Product) {
    if product.discountedPrice == .zero {
      self.informationStackView.spacing = 20.0
      self.priceLabel.isHidden = true
    } else {
      self.informationStackView.spacing = 10.0
      self.priceLabel.isHidden = false
    }
  }
  
  func setStockLabel(_ product: Product) {
    if product.stock == .zero {
      self.stockLabel.textColor = .systemOrange
      self.stockLabel.text = ProductConstant.soldOut
    } else {
      self.stockLabel.textColor = .secondaryLabel
      self.stockLabel.text = "\(ProductConstant.remainStock) \(product.stock)"
    }
  }
  
  func configureUI() {
    self.contentView.layer.borderWidth = 1.0
    self.contentView.layer.cornerRadius = 10.0
    self.contentView.layer.borderColor = UIColor.systemGray.cgColor
    self.contentView.addSubview(containerStackView)
    self.containerStackView.addArrangedSubview(productImageView)
    self.containerStackView.addArrangedSubview(informationStackView)
    
    self.informationStackView.addArrangedSubview(titleLabel)
    self.informationStackView.addArrangedSubview(priceStackView)
    self.informationStackView.addArrangedSubview(stockLabel)
    self.priceStackView.addArrangedSubview(priceLabel)
    self.priceStackView.addArrangedSubview(bargainPriceLabel)
    
    self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
    self.productImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
      productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
      productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
    ])
  }
}
