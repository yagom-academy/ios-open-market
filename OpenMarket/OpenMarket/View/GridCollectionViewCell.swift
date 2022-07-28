//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/28.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let itemImageView = UIImageView()
    private let priceLabel = UILabel()
    private let discountedLabel = UILabel()
    private let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureLayout()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func configureAttribute() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .center
        priceLabel.isHidden = true
        
        discountedLabel.translatesAutoresizingMaskIntoConstraints = false
        discountedLabel.textAlignment = .center
        
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.textAlignment = .center
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.contentMode = .scaleAspectFit
    }
    
    private func configureLayout() {
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(itemImageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(discountedLabel)
        verticalStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configureContent(item: Item) {
        titleLabel.text = "\(item.name)"
        stockLabel.text = "잔여수량: \(item.stock)"
        stockLabel.textColor = .systemGray
        discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
        discountedLabel.textColor = .systemGray
        itemImageView.fetchImageData(url: item.thumbnail)
        
        if item.bargainPrice != 0 {
            priceLabel.isHidden = false
            discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
            priceLabel.textColor = .systemRed
            priceLabel.text = "\(item.currency) \(item.price)"
            
            guard let priceText = priceLabel.text else { return }
            let attribute = NSMutableAttributedString(string: priceText)
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
            priceLabel.attributedText = attribute
            discountedLabel.textColor = .systemGray
        }
        
        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        }
        
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }
    
    func resetContent() {
        priceLabel.text = .none
        priceLabel.attributedText = .none
    }
}

