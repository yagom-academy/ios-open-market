//
//  GridCell.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/23.
//

import UIKit

class GridCell: UICollectionViewCell {
    let productImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let productNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let productPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let productStockLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        [productImageView, productNameLabel, productPriceLabel, productStockLabel].forEach { view in
            totalStackView.addArrangedSubview(view)
        }
        contentView.addSubview(totalStackView)
        contentView.layer.cornerRadius = 6
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
