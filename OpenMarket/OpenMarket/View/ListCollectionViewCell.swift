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
        
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        verticalStackView.distribution = .fillEqually
        verticalStackView.axis = .vertical
        
        titleLabel.textAlignment = .left
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
        
        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            thumbnailView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 50),
            thumbnailView.widthAnchor.constraint(equalToConstant: 50),
            
            verticalStackView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),

            accessoryView.heightAnchor.constraint(equalToConstant: 15),
            accessoryView.widthAnchor.constraint(equalToConstant: 15),
            accessoryView.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor, constant: -10),
            
            stockLabel.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -5)
        ])
    }
}
