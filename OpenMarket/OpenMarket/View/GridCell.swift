//
//  GridCell.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/23.
//

import UIKit

class GridCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemGray2
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
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configureLayout() {
        [imageView, nameLabel, priceLabel, stockLabel].forEach { view in
            totalStackView.addArrangedSubview(view)
        }
        contentView.addSubview(totalStackView)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalTo: totalStackView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
