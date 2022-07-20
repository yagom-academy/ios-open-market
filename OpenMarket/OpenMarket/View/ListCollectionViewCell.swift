//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/20.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    var accessoryView = UIImageView()
    let titleLabel = UILabel()
    let stockLabel = UILabel()
    let priceLabel = UILabel()
    let thumbnailView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.axis = .horizontal
        verticalStackView.distribution = .equalSpacing
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stockLabel.textAlignment = .right
        stockLabel.tintColor = .systemGray
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView = image
        accessoryView.tintColor = .systemGray
        
        contentView.addSubview(thumbnailView)
        contentView.addSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(stockLabel)
        horizontalStackView.addArrangedSubview(accessoryView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(priceLabel)
        
        let contentViewHeight = self.contentView.heightAnchor.constraint(equalToConstant: 100)
        contentViewHeight.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            contentViewHeight,
                
            thumbnailView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            thumbnailView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 70),
            thumbnailView.widthAnchor.constraint(equalToConstant: 70),
            
            verticalStackView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            verticalStackView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
            
            stockLabel.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -5)
        ])
    }
}
