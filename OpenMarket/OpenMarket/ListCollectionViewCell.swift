//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    var productNameLabel: UILabel!
    var productPriceLabel: UILabel!
    var productStockLabel: UILabel!
    var productImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpLabel()
    }
    
    func setUpCell() {
        productNameLabel = UILabel()
        productStockLabel = UILabel()
        productPriceLabel = UILabel()
        productImageView = UIImageView()
        
        productImageView.image = UIImage(named: "macmini")
        productImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        productImageView.contentMode = .scaleAspectFit
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 10
            return stackView
        }()
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(productImageView)
        
        let priceStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            return stackView
        }()
        
        priceStackView.addArrangedSubview(productNameLabel)
        priceStackView.addArrangedSubview(productPriceLabel)
        stackView.addArrangedSubview(priceStackView)
        
        stackView.addArrangedSubview(productStockLabel)
        
        priceStackView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5).isActive = true
        priceStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5).isActive = true
    }
    
    func setUpLabel() {
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        productPriceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        productStockLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
}
