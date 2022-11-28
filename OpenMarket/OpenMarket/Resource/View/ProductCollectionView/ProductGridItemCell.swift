//
//  ProductGridItemCell.swift
//  OpenMarket
//
//  Created by mini on 2022/11/28.
//

import UIKit

final class ProductGridItemCell: ProductItemCell {
    override func configureLayout() {
        super.configureLayout()
        
        setupLayoutGridCell()
    }
    
    func setupLayoutGridCell(){
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            thumbnailImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: stockLabel.topAnchor),
            
            stockLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        subTitleLabel.setContentHuggingPriority(.init(1), for: .vertical)
    }
    
    override func configureStyle() {
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.numberOfLines = 2
            titleLabel.textColor = .label
            titleLabel.adjustsFontForContentSizeCategory = true
            
            titleLabel.textAlignment = .center
            
            subTitleLabel.textColor = .secondaryLabel
            subTitleLabel.font = .preferredFont(forTextStyle: .subheadline)
            subTitleLabel.adjustsFontForContentSizeCategory = true
            subTitleLabel.textAlignment = .center
            subTitleLabel.numberOfLines = 0

            stockLabel.textAlignment = .center
            stockLabel.textColor = .secondaryLabel
            stockLabel.numberOfLines = 2
            stockLabel.font = .preferredFont(forTextStyle: .subheadline)
            stockLabel.adjustsFontForContentSizeCategory = true
            
            thumbnailImageView.layer.cornerRadius = 20
            thumbnailImageView.clipsToBounds = true
            thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
            thumbnailImageView.layer.borderWidth = 0.1
            
            layer.cornerRadius = 20
            layer.borderWidth = 2
            layer.borderColor = UIColor.gray.cgColor
    }
}
