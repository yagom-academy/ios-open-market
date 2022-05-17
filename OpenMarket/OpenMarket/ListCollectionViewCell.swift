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
        // Add SubViews
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
        
        // StackView Constraints
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        // productImageView Constraints
        productImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, constant: -10).isActive = true
        productImageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.15).isActive = true
    }
}

extension UICollectionViewCell {
    func createLabel(font: UIFont, textColor: UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        
        return label
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat, margin: UIEdgeInsets) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = margin
        
        return stackView
    }
    
    func createImageView(contentMode: ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        return imageView
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

protocol Contentable {
    var productNameLabel: UILabel { get }
    var productPriceLabel: UILabel { get }
    var productBargainPriceLabel: UILabel { get }
    var productStockLabel: UILabel { get }
    var productImageView: UIImageView { get }
}
