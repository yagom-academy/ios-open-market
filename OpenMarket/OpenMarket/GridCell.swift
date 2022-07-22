//
//  CollectionViewGridLayoutCell.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/15.
//

import UIKit

final class GridCell: UICollectionViewCell {
    // MARK: - Cell UIComponents
    private let verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.spacing = 0
        return stackview
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Mac mini"
        label.sizeToFit()
        return label
    }()
    
    private let productBargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "JPY 300"
        label.sizeToFit()
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "JPY 800"
        label.sizeToFit()
        return label
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "잔여수량: 20"
        label.sizeToFit()
        return label
    }()
    // MARK: - Cell Initailize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddSubviews()
        setupConstraints()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Cell Setup Method
    private func setupAddSubviews() {
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(productImageView)
        verticalStackView.addArrangedSubview(productNameLabel)
        verticalStackView.addArrangedSubview(productPriceLabel)
        verticalStackView.addArrangedSubview(productBargainPriceLabel)
        verticalStackView.addArrangedSubview(productStockLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 130),
            productImageView.widthAnchor.constraint(equalToConstant: 130),
            productImageView.leadingAnchor.constraint(equalTo: self.verticalStackView.leadingAnchor, constant: 10),
            productImageView.trailingAnchor.constraint(equalTo: self.verticalStackView.trailingAnchor, constant: -10),
            productImageView.heightAnchor.constraint(equalTo: self.productImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupLayer() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 12
    }
    
    func setup(with inputData: Product) {
        self.productImageView.setImageUrl(inputData.thumbnail)
        self.productNameLabel.text = inputData.name
        
        setupProductBargainPriceLabel(with: inputData)
        
        if inputData.stock > 0 {
            self.productStockLabel.text = "잔여수량 : \(inputData.stock)"
            self.productStockLabel.textColor = .lightGray
        } else {
            self.productStockLabel.text = "품절"
            self.productStockLabel.textColor = .orange
        }
    }
    
    private func setupProductBargainPriceLabel(with inputData: Product) {
        if inputData.price == inputData.bargainPrice {
            self.productBargainPriceLabel.isHidden = true
            let price = inputData.price.adoptDecimalStyle()
            self.productPriceLabel.text = "\(inputData.currency.rawValue.uppercased()) " + price
        } else {
            var price = inputData.price.adoptDecimalStyle()
            price = "\(inputData.currency.rawValue.uppercased()) " + price
            self.productPriceLabel.strikethrough(from: price)
            self.productPriceLabel.textColor = .red
            let bargainPrice = inputData.bargainPrice.adoptDecimalStyle()
            self.productBargainPriceLabel.text = "\(inputData.currency.rawValue.uppercased()) " + bargainPrice
        }
    }
    
    override func prepareForReuse() {
        self.productPriceLabel.textColor = .lightGray
        self.productPriceLabel.attributedText = nil
        self.productBargainPriceLabel.isHidden = false
    }
}


