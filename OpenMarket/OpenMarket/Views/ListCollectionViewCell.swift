//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productSalePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
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
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupData(with productData: Product) {
        if let imageURL = URL(string: productData.thumbnail) {
            productImageView.loadImage(url: imageURL)
        }
        
        productNameLabel.text = productData.name
        productPriceLabel.text = String(productData.price)
        productBeforeSalePriceLabel.text = String(productData.price)
        productSalePriceLabel.text = String(productData.bargainPrice)
        productStockLabel.text = String(productData.stock)
        discountPrice = productData.discountedPrice
        
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
    
    private func applyStrikeThroughStyle(label: UILabel) {
        let attributeString = NSMutableAttributedString(string: label.text ?? "")
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
    }
}

// MARK: - Constraints
extension ListCollectionViewCell {
    
    private func setupUI() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        self.addSubview(productImageView)
        self.addSubview(productNameLabel)
        self.addSubview(nextButton)
    }
    
    private func setupPriceLabel() {
        self.addSubview(productStockLabel)
       
        if  discountPrice == Double.zero {
            clearPriceLabel()
            self.addSubview(productPriceLabel)
            setupPriceLabelConstraints()
        } else {
            clearPriceLabel()
            self.addSubview(productBeforeSalePriceLabel)
            self.addSubview(productSalePriceLabel)
            applyStrikeThroughStyle(label: productBeforeSalePriceLabel)
            setupPriceSaleLabelConstraints()
        }
    }
    
    private func clearPriceLabel() {
        productPriceLabel.removeFromSuperview()
        productBeforeSalePriceLabel.removeFromSuperview()
        productSalePriceLabel.removeFromSuperview()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            productImageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 10),
            productImageView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width * 0.2),
            productImageView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -5),
            
            productNameLabel.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -100)
        ])
    }
    
    func setupPriceLabelConstraints() {
        NSLayoutConstraint.activate([
            productPriceLabel.topAnchor.constraint(
                equalTo: productNameLabel.bottomAnchor, constant: 5),
            productPriceLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor, constant: 10),
            
            productPriceLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -10),
            
            nextButton.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 5),
            nextButton.bottomAnchor.constraint(
                lessThanOrEqualTo: self.bottomAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10),
            
            productStockLabel.topAnchor.constraint(
                equalTo: nextButton.topAnchor),
            productStockLabel.trailingAnchor.constraint(
                equalTo: nextButton.leadingAnchor, constant: -5)
        ])
    }
    
    func setupPriceSaleLabelConstraints() {
        NSLayoutConstraint.activate([
            productBeforeSalePriceLabel.topAnchor.constraint(
                equalTo: productNameLabel.bottomAnchor, constant: 5),
            productBeforeSalePriceLabel.leadingAnchor.constraint(
                equalTo: productImageView.trailingAnchor, constant: 10),
            
            
            productSalePriceLabel.topAnchor.constraint(
                equalTo: productBeforeSalePriceLabel.topAnchor),
            productSalePriceLabel.leadingAnchor.constraint(
                equalTo: productBeforeSalePriceLabel.trailingAnchor, constant: 10),
                        
            nextButton.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 5),
            nextButton.bottomAnchor.constraint(
                lessThanOrEqualTo: self.bottomAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10),
            
            productStockLabel.topAnchor.constraint(
                equalTo: nextButton.topAnchor),
            productStockLabel.trailingAnchor.constraint(
                equalTo: nextButton.leadingAnchor, constant: -5)
        ])
    }
}

extension ListCollectionViewCell: ReuseIdentifierProtocol {
    
}
