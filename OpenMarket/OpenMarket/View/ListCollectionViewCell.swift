//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/28.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    private let priceStackView = UIStackView()
    private var accessoryView = UIImageView()
    private let titleLabel = UILabel()
    private let stockLabel = UILabel()
    private let priceLabel = UILabel()
    private let spacingView = UIView()
    private let discountedLabel = UILabel()
    private let thumbnailView = UIImageView()
    
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
        let priceHuggingPriority = discountedLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockHuggingPriority = titleLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockCompressionPriority = titleLabel.contentCompressionResistancePriority(for: .horizontal) + 1
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.axis = .horizontal
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.distribution = .fill
        priceStackView.axis = .horizontal
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.setContentHuggingPriority(stockHuggingPriority, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(stockCompressionPriority, for: .horizontal)
        stockLabel.textAlignment = .right
        
        priceLabel.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
        priceLabel.isHidden = true
        
        discountedLabel.translatesAutoresizingMaskIntoConstraints = false
        discountedLabel.textAlignment = .left
        
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
        
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false

        accessoryView = image
        accessoryView.tintColor = .systemGray
    }
    
    private func configureLayout() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(priceStackView)
        
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(stockLabel)
        horizontalStackView.addArrangedSubview(accessoryView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(spacingView)
        priceStackView.addArrangedSubview(discountedLabel)
        
        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            thumbnailView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 70),
            thumbnailView.widthAnchor.constraint(equalToConstant: 70),
            
            verticalStackView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            verticalStackView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            stockLabel.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -5),
            
            accessoryView.heightAnchor.constraint(equalToConstant: 17),
            accessoryView.widthAnchor.constraint(equalTo: accessoryView.heightAnchor),
            
            spacingView.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    func configureContent(item: Item) {
        titleLabel.text = "\(item.name)"
        stockLabel.text = "잔여수량: \(item.stock)"
        stockLabel.textColor = .systemGray
        discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
        discountedLabel.textColor = .systemGray
        
        if item.bargainPrice != 0 {
            spacingView.isHidden = false
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
        
        DispatchQueue.global().async {
            guard let url = URL(string: item.thumbnail),
                  let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.thumbnailView.image = UIImage(data: imageData)
            }
        }
    }
    
    func resetContent() {
        spacingView.isHidden = true
        priceLabel.text = .none
        priceLabel.attributedText = .none
    }
}

