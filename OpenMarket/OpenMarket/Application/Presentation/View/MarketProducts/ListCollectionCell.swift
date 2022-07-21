//
//  ListCollectionCell.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
//

import UIKit

final class ListCollectionCell: UICollectionViewListCell {
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
     
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let priceLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    private let leftoverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.textAlignment = .right
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureListCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productNameLabel.text = nil
        originalPriceLabel.text = nil
        originalPriceLabel.textColor = .systemGray
        bargainPriceLabel.text = nil
        bargainPriceLabel.textColor = .systemGray
        leftoverLabel.text = nil
        leftoverLabel.textColor = .systemGray
    }
}

extension ListCollectionCell {
    private func configureListCell() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(productImageView)
        rootStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(productNameLabel)
        labelStackView.addArrangedSubview(priceLabelStackView)
        
        priceLabelStackView.addArrangedSubview(originalPriceLabel)
        priceLabelStackView.addArrangedSubview(bargainPriceLabel)
        
        rootStackView.addArrangedSubview(leftoverLabel)
        
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            productImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.2),
            productImageView.heightAnchor.constraint(equalToConstant: contentView.bounds.width * 0.2)
        ])
    }
    
    func updateUI(_ data: ProductEntity) {
        productImageView.image = data.thumbnailImage
        productNameLabel.text = data.name
        originalPriceLabel.text = data.currency + " " + data.originalPrice.numberFormatter()
        originalPriceLabel.numberOfLines = 0
        bargainPriceLabel.text = data.currency + " " + data.discountedPrice.numberFormatter()
        bargainPriceLabel.numberOfLines = 0
        leftoverLabel.text = "잔여수량 : " + String(data.stock)
        
        if data.originalPrice == data.discountedPrice {
            bargainPriceLabel.isHidden = true
            originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: 0)
            originalPriceLabel.textColor = .systemGray
        } else {
            bargainPriceLabel.isHidden = false
            originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: NSUnderlineStyle.single.rawValue)
            originalPriceLabel.textColor = .systemRed
        }
        
        if data.stock == 0 {
            leftoverLabel.text = "품절"
            leftoverLabel.textColor = .systemYellow
        }
    }
}
