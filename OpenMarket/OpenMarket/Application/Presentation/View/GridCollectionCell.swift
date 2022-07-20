//
//  CollectionGridCell.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/17.
//

import UIKit

class CollectionGridCell: UICollectionViewCell {
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        return imageView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
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

extension CollectionGridCell {
    func configure() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(productImageView)
        rootStackView.addArrangedSubview(stackView)
        
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(discountedLabel)
        stackView.addArrangedSubview(stockLabel)

        let inset = CGFloat(10)
            
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
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

extension String {
    func strikeThrough(value: Int) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: value, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
}

extension Int {
    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
