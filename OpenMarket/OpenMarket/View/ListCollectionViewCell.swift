//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/18.
//

import UIKit

final class ListCollectionViewCell: OpenMarketCollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configure() {
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.addArrangedSubview(accessoryImageView)
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2)
        ])
        productStackView.alignment = .leading
        priceStackView.axis = .horizontal
    }
}
