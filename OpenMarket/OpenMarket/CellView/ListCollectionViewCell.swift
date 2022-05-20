//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewListCell, OpenMarketCell {
    
    var productNameLabel: UILabel = UILabel()
    var productImageView: UIImageView = UIImageView()
    var productPriceLabel: UILabel = UILabel()
    var productBargainPriceLabel: UILabel = UILabel()
    var productStockLabel: UILabel = UILabel()
    var mainStackView: UIStackView = UIStackView()
    var priceStackView: UIStackView = UIStackView()
    var informationStackView: UIStackView = UIStackView()
    var nameStockStackView: UIStackView = UIStackView()
    
    private let numberFormatter = NumberFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        productNameLabel = createLabel(font: .preferredFont(forTextStyle: .headline), textColor: .black, alignment: .natural)
        productPriceLabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .left)
        productBargainPriceLabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .left)
        productStockLabel = createLabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .systemGray, alignment: .right)
        productImageView = createImageView(contentMode: .scaleAspectFit)
        mainStackView = createStackView(axis: .horizontal, alignment: .top, distribution: .fillProportionally, spacing: 5, margin: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        informationStackView = createStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 0)
        nameStockStackView = createStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 0)
        priceStackView = createStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 5)
        
        setUpSubViewStructure()
        setUpLayoutConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubViewStructure()
        setUpLayoutConstraints()
    }
    
    func setUpSubViewStructure() {
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
    
    func setUpLayoutConstraints() {
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
    
    func configureCellContents(product: Product) {
        guard let currency = product.currency?.rawValue else {
            return
        }
        productNameLabel.text = product.name
        productPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for: product.price))"
        productImageView.requestImageDownload(url: product.thumbnail)
        guard let price = productPriceLabel.text else {
            return
        }
        
        if product.discountedPrice != 0 {
            productBargainPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for: product.bargainPrice))"
            productPriceLabel.textColor = .red
            productPriceLabel.attributedText = setTextAttribute(of: price, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        }
        if product.stock == 0 {
            productStockLabel.text = "품절"
            productStockLabel.textColor = .systemOrange
        } else {
            productStockLabel.text = "잔여수량 :  \(String(product.stock))"
        }
    }
    
    private func setTextAttribute(of target: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: target)
        attributedText.addAttributes(attributes, range: (target as NSString).range(of: target))
        
        return attributedText
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
        setUpLayoutConstraints()
    }
}


