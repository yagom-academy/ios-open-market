//
//  OpenMarketListCollectionViewCell.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/17.
//

import UIKit

final class OpenMarketListCollectionViewCell: OpenMarketCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureListCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureListCellLayout()
    }
    
    private func configureListCellLayout() {
        containerStackView.addArrangedSubview(accessoryImageView)
        configureStackView()
        configureAccessoryImageView()
        priceStackView.axis = .horizontal
    }
    
    private func configureStackView() {
        containerStackView.axis = .horizontal
        containerStackView.alignment = .top
        containerStackView.distribution = .fill
    }
    
    private func configureAccessoryImageView() {
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
}
