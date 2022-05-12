//
//  ProductCell.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/12.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameLabel, priceStackView, QuantityLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, bargainPriceLabel])
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.axis = .vertical
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .center
        return label
    }()
    
    private let QuantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        layer.cornerRadius = 10
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    private func configureLayout() {
        contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: productStackView.widthAnchor, multiplier: 0.7),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }
    
    func configure(data: Product?) {
        thumbnailImageView.image = UIImage(systemName: "swift")
        nameLabel.text = data?.name
        
        if data?.price == data?.bargainPrice {
            bargainPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray3
        } else {
            bargainPriceLabel.isHidden = false
            priceLabel.textColor = .systemRed
        }
        
        priceLabel.text = "\(data?.currency?.rawValue ?? "USD") \(data?.price ?? 1.0)"
        bargainPriceLabel.text = "\(data?.currency?.rawValue ?? "USD") \(data?.bargainPrice ?? 1.0)"
        
        QuantityLabel.textColor = data?.stock == 0 ? .systemOrange : .systemGray3
        QuantityLabel.text = data?.stock == 0 ? "품절" : "잔여수량: \(data?.stock ?? 0)"
    }
}
