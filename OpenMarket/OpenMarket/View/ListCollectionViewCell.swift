//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/20.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    private let priceStackView = UIStackView()
    var accessoryView = UIImageView()
    let titleLabel = UILabel()
    let stockLabel = UILabel()
    let priceLabel = UILabel()
    let spacingView = UIView()
    let discountedLabel = UILabel()
    let thumbnailView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHorizontalStackView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private func configureHorizontalStackView() {
        let priceHuggingPriority = discountedLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockHuggingPriority = titleLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockCompressionPriority = titleLabel.contentCompressionResistancePriority(for: .horizontal) + 1
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        discountedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.axis = .horizontal
        priceStackView.distribution = .fill
        priceStackView.axis = .horizontal
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stockLabel.setContentHuggingPriority(stockHuggingPriority, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(stockCompressionPriority, for: .horizontal)
        stockLabel.textAlignment = .right
        priceLabel.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
        priceLabel.isHidden = true
        spacingView.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
        discountedLabel.textAlignment = .left
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView = image
        accessoryView.tintColor = .systemGray
        
        contentView.addSubview(thumbnailView)
        contentView.addSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(stockLabel)
        horizontalStackView.addArrangedSubview(accessoryView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(priceStackView)
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
}
