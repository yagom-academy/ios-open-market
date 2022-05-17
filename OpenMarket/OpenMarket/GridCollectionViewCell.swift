//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    lazy var productNameLabel = createLabel(font: .preferredFont(for: .title3, weight: .semibold), textColor: .black, alignment: .center)
    
    lazy var productImageView = createImageView(contentMode: .scaleAspectFit)
    
    lazy var productPriceLabel = createLabel(font: .preferredFont(forTextStyle: .body), textColor: .systemGray, alignment: .center)
    
    lazy var productBargainPriceLabel = createLabel(font: .preferredFont(forTextStyle: .body), textColor: .systemGray, alignment: .center)
    
    lazy var productStockLabel = createLabel(font: .preferredFont(forTextStyle: .body), textColor: .systemGray, alignment: .center)
    
    lazy var stackView = createStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 5, margin: UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10))
    
    lazy var stackView0 = createStackView(axis: .vertical, alignment: .center, distribution: .fillProportionally, spacing: 0)
    
    lazy var stackView1 = createStackView(axis: .vertical, alignment: .center, distribution: .fillEqually, spacing: 5)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }

    func setUpCell() {
        // Add SubViews
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(productImageView)
        stackView.addArrangedSubview(stackView1)
        
        stackView1.addArrangedSubview(productNameLabel)
        stackView1.addArrangedSubview(stackView0)
        stackView1.addArrangedSubview(productStockLabel)
        
        stackView0.addArrangedSubview(productPriceLabel)
        stackView0.addArrangedSubview(productBargainPriceLabel)
        
        // StackView Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        productImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5).isActive = true
    }
}

extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}

extension GridCollectionViewCell {
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
        
        productImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5).isActive = true
    }
}
