//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class ListCollectionViewCell: UICollectionViewListCell {
    lazy var productNameLabel = createLabel(font: .preferredFont(forTextStyle: .headline), textColor: .black, alignment: .natural)
    
    lazy var productPriceLabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .left)
    
    lazy var productBargainPriceLabel: UILabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .left)
    
    lazy var productStockLabel: UILabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .right)
    
    lazy var productImageView = createImageView(contentMode: .scaleAspectFit)
    
    lazy var stackView = createStackView(axis: .horizontal, alignment: .top, distribution: .fillProportionally, spacing: 5, margin: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    
    lazy var stackView0 = createStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 0)
    
    lazy var stackView1 = createStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 0)
    
    lazy var stackView2 = createStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 0)
    
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(productImageView)
        stackView0.addArrangedSubview(stackView1)
        stackView0.addArrangedSubview(stackView2)
        stackView.addArrangedSubview(stackView0)
        stackView1.addArrangedSubview(productNameLabel)
        stackView1.addArrangedSubview(productStockLabel)
        stackView2.addArrangedSubview(productPriceLabel)
        stackView2.addArrangedSubview(productBargainPriceLabel)
    }
    
    func configureLayoutConstraints() {
        stackView0.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        
        productNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productStockLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        productNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        productStockLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        productPriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productBargainPriceLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // StackView Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        // productImageView Constraints
        productImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -10).isActive = true
        productImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.15).isActive = true
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
