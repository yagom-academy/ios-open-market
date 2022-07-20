//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/20.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    private let priceStackView = UIStackView()
    var accessoryView = UIImageView()
    let titleLabel = UILabel()
    let stockLabel = UILabel()
    let priceLabel = UILabel()
    let discountedLabel = UILabel()
    let thumbnailView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHorizontalStackView() {
        let pricePriority = discountedLabel.contentHuggingPriority(for: .horizontal) + 1
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        discountedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.axis = .horizontal
        priceStackView.distribution = .fill
        priceStackView.axis = .horizontal
        priceStackView.spacing = 6
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stockLabel.textAlignment = .right
        priceLabel.setContentHuggingPriority(pricePriority, for: .horizontal)
        discountedLabel.isHidden = true
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
        priceStackView.addArrangedSubview(discountedLabel)
        
        let contentViewHeight = self.contentView.heightAnchor.constraint(equalToConstant: 100)
        contentViewHeight.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            contentViewHeight,
                
            thumbnailView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            thumbnailView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 70),
            thumbnailView.widthAnchor.constraint(equalToConstant: 70),
            
            verticalStackView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            verticalStackView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
            
            stockLabel.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -5)
        ])
    }
}
