//
//  GridCell.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/23.
//

import UIKit

class GridCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let stockLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
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
        [imageView, nameLabel, priceLabel, stockLabel].forEach { view in
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
