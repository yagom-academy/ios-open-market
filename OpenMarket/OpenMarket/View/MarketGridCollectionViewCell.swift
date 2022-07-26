//
//  MarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/19.
//

import UIKit

final class MarketGridCollectionViewCell: MarketCollectionViewCell {
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private func arrangeSubView() {
        priceLabel.textAlignment = .center
        
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(stockLabel)
        
        contentView.addSubview(verticalStackView)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray3.cgColor
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.58)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
