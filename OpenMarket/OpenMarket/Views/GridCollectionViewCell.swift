//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    private var discountPrice: Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751),
                                                          for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productBeforeSalePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productSalePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func setupData(with productData: Product) {
        if let imageURL = URL(string: productData.thumbnail) {
            productImageView.loadImage(url: imageURL)
        }
        
        discountPrice = productData.discountedPrice
        
        productNameLabel.text = productData.name
        productPriceLabel.text = String(productData.price)
        productBeforeSalePriceLabel.text = String(productData.price)
        productSalePriceLabel.text = String(productData.bargainPrice)
        productStockLabel.text = productData.stockDescription
        
        setupStockLabel()
        setupPriceLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.text = nil
        productPriceLabel.text = nil
        productBeforeSalePriceLabel.text = nil
        productSalePriceLabel.text = nil
        productStockLabel.text = nil
    }
    
    private func applyStrikeThroghtStyle(label: UILabel) {
        let attributeString = NSMutableAttributedString(string: label.text ?? "")
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
    }
}

// MARK: - Constraints
extension GridCollectionViewCell {
    func setupUI() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        setupStackView()
    }
    
    func setupStackView() {
        productStackView.addArrangedSubview(productImageView)
        productStackView.addArrangedSubview(productNameLabel)
        addSubview(productStackView)
        setupStackViewConstraints()
    }
    
    private func setupStockLabel() {
        if productStockLabel.text == "품절" {
            productStockLabel.textColor = .systemOrange
            self.addSubview(productStockLabel)
        } else {
            productStockLabel.textColor = .gray
            self.addSubview(productStockLabel)
        }
    }
    
    private func setupPriceLabel() {
        if discountPrice == Double.zero {
            clearPriceLabel()
            self.addSubview(productPriceLabel)
            setupBottomLabelConstraints()
        } else {
            clearPriceLabel()
            self.addSubview(productBeforeSalePriceLabel)
            self.addSubview(productSalePriceLabel)
            applyStrikeThroghtStyle(label: productBeforeSalePriceLabel)
            setupBottomSaleLabelConstraints()
        }
    }
    
    private func clearPriceLabel() {
        productPriceLabel.removeFromSuperview()
        productBeforeSalePriceLabel.removeFromSuperview()
        productSalePriceLabel.removeFromSuperview()
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 10),
            productStackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 10),
            productStackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupBottomLabelConstraints() {
        NSLayoutConstraint.activate([
            productPriceLabel.topAnchor.constraint(
                equalTo: productStackView.bottomAnchor, constant: 10),
            productPriceLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            
            productStockLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            productStockLabel.topAnchor.constraint(
                equalTo: productPriceLabel.bottomAnchor, constant: 10),
            productStockLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupBottomSaleLabelConstraints() {
        NSLayoutConstraint.activate([
            productBeforeSalePriceLabel.topAnchor.constraint(
                equalTo: productStackView.bottomAnchor, constant: 5),
            productBeforeSalePriceLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            
            productSalePriceLabel.topAnchor.constraint(
                equalTo: productBeforeSalePriceLabel.bottomAnchor, constant: 1),
            productSalePriceLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            
            productStockLabel.topAnchor.constraint(
                equalTo: productSalePriceLabel.bottomAnchor, constant: 10),
            productStockLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            productStockLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}

extension GridCollectionViewCell: ReuseIdentifierProtocol {
    
}
