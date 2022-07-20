//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/20.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    private let verticalStackView = UIStackView()
    let titleLabel = UILabel()
    let itemImageView = UIImageView()
    let priceLabel = UILabel()
    let discountedLabel = UILabel()
    let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        discountedLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.distribution = .equalCentering
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        
        titleLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        discountedLabel.isHidden = true
        discountedLabel.textAlignment = .center
        stockLabel.textAlignment = .center
        
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(itemImageView)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(discountedLabel)
        verticalStackView.addArrangedSubview(stockLabel)
    }
}
