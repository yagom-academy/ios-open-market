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
        titleLabel.textAlignment = .center
        subTitleLabel.textAlignment = .center
        stockLabel.textAlignment = .center
        
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
    }
}
