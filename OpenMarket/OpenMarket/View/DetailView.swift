//
//  DetailView.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class DetailView: UIView {
  enum Constants {
    static let title: Double = 16.0
    static let body: Double = 15.0
    static let spacing: Double = 5.0
  }
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = .white
    self.translatesAutoresizingMaskIntoConstraints = false
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //MARK: - Top part of View
  private let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .white
    return scrollView
  }()
  
  private let imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  //MARK: - Middle part of View
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: Constants.title, weight: .bold)
    label.numberOfLines = 0
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = .systemFont(ofSize: Constants.body)
    label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    label.textColor = .systemGray
    return label
  }()
  
  private let bargainPriceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = .systemFont(ofSize: Constants.body)
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = .systemFont(ofSize: Constants.body)
    return label
  }()
  
  private let verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .trailing
    stackView.distribution = .fillEqually
    stackView.spacing = Constants.spacing
    stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
    return stackView
  }()
  
  private let infoStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .top
    stackView.distribution = .fill
    return stackView
  }()
  
  //MARK: - Bottom part of View
  private let descriptionScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isScrollEnabled = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let descriptionView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .left
    label.font = .systemFont(ofSize: Constants.body)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private func configureLayout() {
    self.addSubview(totalStackView)
    totalStackView.addArrangedSubviews(imageScrollView, infoStackView, descriptionScrollView)
    imageScrollView.addSubview(imageStackView)
    infoStackView.addArrangedSubviews(nameLabel, verticalStackView)
    verticalStackView.addArrangedSubviews(stockLabel, priceLabel, bargainPriceLabel)
    descriptionScrollView.addSubview(descriptionView)
    descriptionView.addSubview(descriptionLabel)
    
    NSLayoutConstraint.activate([
      totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      totalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      totalStackView.topAnchor.constraint(equalTo: self.topAnchor),
      totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      imageScrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
      infoStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
      
      imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
      imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
      imageStackView.topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
      imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
      imageStackView.heightAnchor.constraint(equalTo: imageStackView.heightAnchor, multiplier: 1),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor),
      descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor),
      
      descriptionView.leadingAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.leadingAnchor),
      descriptionView.trailingAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.trailingAnchor),
      descriptionView.topAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.topAnchor),
      descriptionView.bottomAnchor.constraint(equalTo: descriptionScrollView.contentLayoutGuide.bottomAnchor),
      descriptionView.widthAnchor.constraint(equalTo: descriptionScrollView.widthAnchor, multiplier: 1)
    ])
  }
  
  func setUpDetailInformation(of detailProduct: DetailProduct) {
    setUpImage(of: detailProduct.images)
    self.nameLabel.text = detailProduct.name
    self.descriptionLabel.text = detailProduct.description
    
    if detailProduct.discountedPrice == 0 {
      self.priceLabel.isHidden = true
      self.bargainPriceLabel.text = "\(detailProduct.currency.text)\(detailProduct.bargainPrice!.formatToDecimal())"
    } else {
      self.priceLabel.textColor = .systemRed
      self.priceLabel
        .attributedText = "\(detailProduct.currency.text)\(detailProduct.price!.formatToDecimal())".strikeThrough()
      self.bargainPriceLabel.text = "\(detailProduct.currency.text)\(detailProduct.bargainPrice!.formatToDecimal())"
    }
    
    if detailProduct.stock == 0 {
      self.stockLabel.textColor = .systemYellow
      self.stockLabel.text = "품절"
    } else {
      self.stockLabel.textColor = .systemGray
      self.stockLabel.text = "남은 수량 : \(detailProduct.stock)"
    }
  }
  
  private func setUpImage(of images: [Image]) {
    images.forEach { image in
      let imageView = UIImageView()
      imageView.loadImage(urlString: image.url)
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
      imageStackView.addArrangedSubview(imageView)
    }
  }
}
