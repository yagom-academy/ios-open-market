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
        configureStackView()
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.9)
        ])
        priceStackView.axis = .vertical
    }
    
    private func configureStackView() {
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.distribution = .equalSpacing
    }
    
}
