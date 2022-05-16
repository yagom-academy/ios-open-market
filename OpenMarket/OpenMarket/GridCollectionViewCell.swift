//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.font = UIFont.preferredFont(for: .title3, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "macmini")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let productBargainPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    
    let productStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10)
        
        
        return stackView
    }()
    
    let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let vStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()

    
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
        stackView.addArrangedSubview(vStackView2)
        
        vStackView2.addArrangedSubview(productNameLabel)
        vStackView2.addArrangedSubview(vStackView)
        vStackView2.addArrangedSubview(productStockLabel)
        
        vStackView.addArrangedSubview(productPriceLabel)
        vStackView.addArrangedSubview(productBargainPriceLabel)
        
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
