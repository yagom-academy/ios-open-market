//
//  CollectionListViewCell.swift
//  OpenMarket
//
//  Created by derrick on 2022/07/17.
//

import UIKit

@available(iOS 14.0, *)
class CollectionListViewCell: UICollectionViewListCell {
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .fill
        
        return stackView
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
     
        return imageView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    let secondaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    let discountedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.textAlignment = .right
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productNameLabel.text = nil
        priceLabel.text = nil
        priceLabel.textColor = .systemGray
        discountedLabel.text = nil
        discountedLabel.textColor = .systemGray
        stockLabel.text = nil
        stockLabel.textColor = .systemGray
    }
}

@available(iOS 14.0, *)
extension CollectionListViewCell {
    func configure() {

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(productImageView)
        rootStackView.addArrangedSubview(stackView)
        
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(secondaryStackView)
        
        secondaryStackView.addArrangedSubview(priceLabel)
        secondaryStackView.addArrangedSubview(discountedLabel)
        
        rootStackView.addArrangedSubview(stockLabel)
        
        productImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.2).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: contentView.bounds.width * 0.2).isActive = true
        
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func config(_ data: ProductEntity) {
        productImageView.image = data.thumbnailImage
        productNameLabel.text = data.name
        priceLabel.text = data.currency + " " + data.originalPrice.numberFormatter()
        priceLabel.numberOfLines = 0
        discountedLabel.text = data.currency + " " + data.discountedPrice.numberFormatter()
        discountedLabel.numberOfLines = 0
        stockLabel.text = "잔여수량 : " + String(data.stock)
        
        if data.originalPrice == data.discountedPrice {
            discountedLabel.isHidden = true
            priceLabel.attributedText = priceLabel.text?.strikeThrough(value: 0)
            priceLabel.textColor = .systemGray
        } else {
            discountedLabel.isHidden = false
            priceLabel.attributedText = priceLabel.text?.strikeThrough(value: NSUnderlineStyle.single.rawValue)
            priceLabel.textColor = .systemRed
        }
        
        if data.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        }
    }
}
