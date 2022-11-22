//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/22.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "listCell"
    
    let productImage = UIImageView()
    let productNameLabel = UILabel()
    let priceLabel = UILabel()
    let priceForSaleLabel = UILabel()
    let stockLabel = UILabel()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(productImage)
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(stockLabel)
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(priceStackView)
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(priceForSaleLabel)
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
}
