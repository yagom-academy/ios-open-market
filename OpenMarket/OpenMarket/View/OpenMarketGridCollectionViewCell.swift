//
//  OpenMarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/17.
//

import UIKit

final class OpenMarketGridCollectionViewCell: OpenMarketCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGridCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureGridCellLayout()
    }
    
    private func configureGridCellLayout() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9)
        ])
        priceStackView.axis = .vertical
    }
    
}
