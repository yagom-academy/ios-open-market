//
//  ProductInformationCell.swift
//  OpenMarket
//
//  Created by 강인희 on 2021/01/29.
//

import UIKit

class ProductInformationCell: UITableViewCell {
    static let identifier = "productInformationCell"
    
    let thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView()
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        return thumbnailImageView
    }()
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    let stockLabel: UILabel = {
        let stockLabel = UILabel()
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        return stockLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addToContentView()
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addToContentView() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
    }
    
    private func setUpCell() {
        let margin: CGFloat = 20
        NSLayoutConstraint.activate([
            thumbnailImageView.centerYAnchor.constraint(equalTo:self.centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 50),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: margin),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: margin),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            priceLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            stockLabel.centerYAnchor.constraint(equalTo:self.centerYAnchor),
            stockLabel.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -margin)
        ])
    }

}
