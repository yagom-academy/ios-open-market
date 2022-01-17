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
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.addArrangedSubview(accessoryImageView)
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2)
        ])
        priceStackView.axis = .horizontal
    }
    
}
