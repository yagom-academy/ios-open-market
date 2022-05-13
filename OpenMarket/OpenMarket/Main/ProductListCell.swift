//
//  ProductListCell.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/12.
//

import UIKit

final class ProductListCell: UICollectionViewCell {
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, informationStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, QuantityLabel, ])
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.setContentHuggingPriority(.low, for: .horizontal)
        return label
    }()
    
    private let QuantityLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, bargainPriceLabel])
        stackView.spacing = 8
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.setContentHuggingPriority(.low, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ProductListCell Method

extension ProductListCell {
    private func configureLayout() {
        contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.heightAnchor.constraint(equalTo: productStackView.heightAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        nameLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        QuantityLabel.textColor = .label
        QuantityLabel.text = nil
    }
    
    func configure(data: Product) {
        nameLabel.text = data.name
        
        priceLabel.text = data.price?.priceFormat(currency: data.currency?.rawValue)
        bargainPriceLabel.text = data.bargainPrice?.priceFormat(currency: data.currency?.rawValue)
        
        if data.price == data.bargainPrice {
            bargainPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray3
        } else {
            bargainPriceLabel.isHidden = false
            priceLabel.textColor = .systemRed
            priceLabel.addStrikethrough()
        }
        
        QuantityLabel.textColor = data.stock == 0 ? .systemOrange : .systemGray3
        QuantityLabel.text = data.stock == 0 ? "품절" : "잔여수량: \(data.stock ?? 0)"
    }
    
    func setImage(with image: UIImage) {
        thumbnailImageView.image = image
    }
}


