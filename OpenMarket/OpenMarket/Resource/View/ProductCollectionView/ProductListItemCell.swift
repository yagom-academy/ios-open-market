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
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.numberOfLines = 2
            titleLabel.textColor = .label
            titleLabel.adjustsFontForContentSizeCategory = true
            
            titleLabel.textAlignment = .left
            
            subTitleLabel.textColor = .secondaryLabel
            subTitleLabel.font = .preferredFont(forTextStyle: .subheadline)
            subTitleLabel.adjustsFontForContentSizeCategory = true
            subTitleLabel.textAlignment = .left
            subTitleLabel.numberOfLines = 0

            stockLabel.textAlignment = .right
            stockLabel.textColor = .secondaryLabel
            stockLabel.numberOfLines = 2
            stockLabel.font = .preferredFont(forTextStyle: .subheadline)
            stockLabel.adjustsFontForContentSizeCategory = true
            
            thumbnailImageView.layer.cornerRadius = 20
            thumbnailImageView.clipsToBounds = true
            thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
            thumbnailImageView.layer.borderWidth = 0.1
            
            layer.cornerRadius = 0
            layer.borderWidth = 0
            layer.borderColor = nil
    }
}
