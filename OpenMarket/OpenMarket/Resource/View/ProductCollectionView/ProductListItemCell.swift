//
//  ProductListItemCell.swift
//  OpenMarket
//
//  Created by mini on 2022/11/28.
//

import UIKit

final class ProductListItemCell: ProductItemCell {
    override func configureLayout() {
        super.configureLayout()
        
        setupLayoutListCell()
    }
    
    func setupLayoutListCell() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor, constant: -8),
            
            subTitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stockLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    override func configureStyle() {
        titleLabel.textAlignment = .left
        subTitleLabel.textAlignment = .left
        stockLabel.textAlignment = .right
        
        layer.cornerRadius = 0
        layer.borderWidth = 0
        layer.borderColor = nil
    }
}
