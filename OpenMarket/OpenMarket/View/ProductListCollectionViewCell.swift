//
//  ProductListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/16.
//

import UIKit

final class ProductListCollectionViewCell: UICollectionViewCell {
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 6.0
    return stackView
  }()
  
  private let informationStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let priceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 6.0
    return stackView
  }()
  
  private let quantityStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .top
    return stackView
  }()

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
    label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    return label
  }()
  
  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.textAlignment = .right
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
  
  func setUp(product: Product) {
    self.setStockLabel(product)
    self.titleLabel.text = product.name
    self.priceLabel.isHidden = product.discountedPrice == .zero
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

private extension ProductListCollectionViewCell {
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
    self.addBottomBorder(thickness: 1.0)
    self.contentView.addSubview(containerStackView)
    self.containerStackView.addArrangedSubview(productImageView)
    self.containerStackView.addArrangedSubview(informationStackView)
    self.containerStackView.addArrangedSubview(quantityStackView)
    
    self.informationStackView.addArrangedSubview(titleLabel)
    self.informationStackView.addArrangedSubview(priceStackView)
    self.priceStackView.addArrangedSubview(priceLabel)
    self.priceStackView.addArrangedSubview(bargainPriceLabel)
    
    self.quantityStackView.addArrangedSubview(stockLabel)
    self.quantityStackView.addArrangedSubview(disclosureImageView)
    
    self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
    self.productImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stockLabel.widthAnchor.constraint(equalTo: disclosureImageView.widthAnchor, multiplier: 9.0),
      productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
      productImageView.widthAnchor.constraint(
        equalTo: productImageView.heightAnchor,
        multiplier: 1.0),
      informationStackView.widthAnchor.constraint(
        lessThanOrEqualToConstant: contentView.bounds.width * 0.5
      )
    ])
  }
  
  func addBottomBorder(thickness: CGFloat) {
    let border = CALayer()
    border.frame = CGRect(
      x: .zero,
      y: contentView.frame.height - thickness,
      width: contentView.frame.width,
      height: thickness)
    border.backgroundColor = UIColor.systemGray4.cgColor
    self.contentView.layer.addSublayer(border)
  }
}
