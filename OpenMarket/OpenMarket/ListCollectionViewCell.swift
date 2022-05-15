//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let productStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
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
        stackView.spacing = 10
        return stackView
    }()
    
    let priceStackView: UIStackView = {
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
        priceStackView.addArrangedSubview(productNameLabel)
        priceStackView.addArrangedSubview(productPriceLabel)
        stackView.addArrangedSubview(priceStackView)
        stackView.addArrangedSubview(productStockLabel)
        
        
        // StackView Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        // productImageView Constraints
        productImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        productImageView.contentMode = .scaleAspectFit
     
        
        // priceStackView Constaints
        priceStackView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        priceStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
}
