//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/18.
//

import UIKit

final class GridCollectionViewCell: OpenMarketCollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configure() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9)
        ])
        productStackView.alignment = .center
        priceStackView.axis = .vertical
    }
}
