//
//  ProductCell.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/12.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameLabel, bargainPriceLabel, discountedPriceLabel, QuantityLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }
    
    func configure(data: Product?) {
        thumbnailImageView.image = UIImage(systemName: "swift")
        nameLabel.text = data?.name
        bargainPriceLabel.text = "\(data?.currency?.rawValue ?? "USD") \(data?.bargainPrice ?? 1.0)"
        discountedPriceLabel.text = "\(data?.currency?.rawValue ?? "USD") \(data?.discountedPrice ?? 1.0)"
        QuantityLabel.text = data?.stock == 0 ? "품절" : "잔여수량: \(data?.stock ?? 0)"
    }
}
