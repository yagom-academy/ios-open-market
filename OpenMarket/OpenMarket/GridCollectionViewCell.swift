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
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
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
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let productStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
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
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(vStackView)
        stackView.addArrangedSubview(productStockLabel)
        vStackView.addArrangedSubview(productBargainPriceLabel)
        vStackView.addArrangedSubview(productPriceLabel)
        
        // StackView Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
        // productNameLabel Constraints
        productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor).isActive = true
        
        // productImageView Constraints
        productImageView.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        
        // vertical StackView Constraints
        vStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor).isActive = true
    }
}
