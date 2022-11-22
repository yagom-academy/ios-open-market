//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
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
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
    
    let productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}

// MARK: - Constraints
extension GridCollectionViewCell {
    
    func setupUI() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        setupStackView()
        setupPriceLabel()
    }
    
    func setupStackView() {
        productStackView.addArrangedSubview(productImageView)
        productStackView.addArrangedSubview(productNameLabel)
        addSubview(productStackView)
        setupStackViewConstraints()
    }
    
    func setupPriceLabel() {
        self.addSubview(productPriceLabel)
        self.addSubview(productStockLabel)
        
        if productSalePriceLabel.text == "0.0" {
            setupBottomLabelConstraints()
        } else {
            self.addSubview(productSalePriceLabel)
            setupBottomSaleLabelConstraints()
        }
    }
    
    func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 10),
            productStackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 10),
            productStackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func setupBottomLabelConstraints() {
        NSLayoutConstraint.activate([
            productPriceLabel.topAnchor.constraint(equalTo: productStackView.bottomAnchor, constant: 10),
            productPriceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
     
            productStockLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            productStockLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 10),
            productStockLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func setupBottomSaleLabelConstraints() {
        NSLayoutConstraint.activate([
            productSalePriceLabel.topAnchor.constraint(equalTo: productStackView.bottomAnchor, constant: 10),
            productSalePriceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            productPriceLabel.topAnchor.constraint(equalTo: productSalePriceLabel.bottomAnchor, constant: 1),
            productPriceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            productStockLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 10),
            productStockLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            productStockLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}

extension GridCollectionViewCell: ReuseIdentifierProtocol {
    
}
