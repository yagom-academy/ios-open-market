//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class ListCollectionViewCell: UICollectionViewListCell, Contentable {
    lazy var productNameLabel = createLabel(font: .preferredFont(forTextStyle: .headline), textColor: .black, alignment: .natural)
    lazy var productPriceLabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .left)
    lazy var productBargainPriceLabel: UILabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .left)
    lazy var productStockLabel: UILabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .right)
    lazy var productImageView = createImageView(contentMode: .scaleAspectFit)
    lazy var mainStackView = createStackView(axis: .horizontal, alignment: .top, distribution: .fillProportionally, spacing: 5, margin: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    lazy var informationStackView = createStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 0)
    lazy var nameStockStackView = createStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 0)
    lazy var priceStackView = createStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    func setUpCell() {
        configureSubViewStructure()
        configureLayoutConstraints()
    }
    
    func configureSubViewStructure() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(productImageView)
        informationStackView.addArrangedSubview(nameStockStackView)
        informationStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(informationStackView)
        nameStockStackView.addArrangedSubview(productNameLabel)
        nameStockStackView.addArrangedSubview(productStockLabel)
        priceStackView.addArrangedSubview(productPriceLabel)
        priceStackView.addArrangedSubview(productBargainPriceLabel)
    }
    
    func configureLayoutConstraints() {
        informationStackView.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor).isActive = true
        
        productNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productStockLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        productNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        productStockLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        productPriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productBargainPriceLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        productImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, constant: -10).isActive = true
        productImageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.15).isActive = true
    }
}

extension ListCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        productNameLabel.text = ""
        productPriceLabel.attributedText = nil
        productPriceLabel.textColor = .systemGray
        productPriceLabel.text = ""
        
        productStockLabel.textColor = .systemGray
        productStockLabel.text = ""
        productBargainPriceLabel.textColor = .systemGray
        productBargainPriceLabel.text = ""
        configureLayoutConstraints()
    }
}


