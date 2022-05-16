//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class ListCollectionViewCell: UICollectionViewListCell {
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        return label
    }()
    
    let productBargainPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        return label
    }()
    
    let productStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "macmini")
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .top
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    func setUpCell() {
        // Add SubViews
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(productImageView)
        informationStackView.addArrangedSubview(productNameLabel)
        priceStackView.addArrangedSubview(productPriceLabel)
        priceStackView.addArrangedSubview(productBargainPriceLabel)
        informationStackView.addArrangedSubview(priceStackView)
        stackView.addArrangedSubview(informationStackView)
        stackView.addArrangedSubview(productStockLabel)
        
        
        // StackView Constraints
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        informationStackView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        
        // productImageView Constraints
        productImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        productImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.135).isActive = true
        productImageView.contentMode = .scaleAspectFit
    }
}
