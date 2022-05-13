//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    var productNameLabel: UILabel!
    var productPriceLabel: UILabel!
    var productImageView: UIImageView!
    var productStockLabel: UILabel!
    var productBargainPriceLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
        setUpLabel()
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    func setUpCell() {
        productNameLabel = UILabel()
        productPriceLabel = UILabel()
        productImageView = UIImageView()
        productImageView.image = UIImage(named: "macmini")
        productImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        productImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        let vStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            return stackView
        }()
        productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 5).isActive = true
        
        vStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5).isActive = true
        
        vStackView.addArrangedSubview(productBargainPriceLabel)
        vStackView.addArrangedSubview(productPriceLabel)
        
        stackView.addArrangedSubview(productImageView)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(vStackView)
        stackView.addArrangedSubview(productStockLabel)
        
    }
    
    func setUpLabel() {
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        productPriceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        productBargainPriceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        productStockLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
}
