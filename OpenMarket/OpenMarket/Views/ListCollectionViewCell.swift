//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productSalePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productStockLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        return button
    }()
}

// MARK: - Constraints
extension ListCollectionViewCell {
    
    func setupUI() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        self.addSubview(productImageView)
        self.addSubview(productNameLabel)
        self.addSubview(productPriceLabel)
        self.addSubview(productStockLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            productImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
            
            productNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productPriceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            productStockLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            productStockLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
}

extension ListCollectionViewCell: ReuseIdentifierProtocol {
    
}
