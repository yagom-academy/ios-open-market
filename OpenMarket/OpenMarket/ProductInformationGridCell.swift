//
//  ProductInformationGridCell.swift
//  OpenMarket
//
//  Created by 강인희 on 2021/02/01.
//

import UIKit

class ProductInformationGridCell: UICollectionViewCell {
    
    static let identifier = "productInformationGridCell"
    
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
    let discountedPriceLabel: UILabel = {
        let discountedPriceLabel = UILabel()
        discountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        return discountedPriceLabel
    }()
    let stockLabel: UILabel = {
        let stockLabel = UILabel()
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        return stockLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        contentView.addSubview(discountedPriceLabel)
        contentView.addSubview(stockLabel)
    }
    
    private func setUpCell() {
        nameLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        discountedPriceLabel.textAlignment = .center
        stockLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            nameLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor,constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            
            discountedPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            discountedPriceLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            discountedPriceLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            
            
            stockLabel.topAnchor.constraint(equalTo: discountedPriceLabel.bottomAnchor, constant: 10),
            stockLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
        ])
    }

}
