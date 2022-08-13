//
//  GridCell.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/18.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - functions
    override func prepareForReuse() {
        productImageView.image = nil
        productNameLabel.text = nil
        priceLabel.attributedText = nil
        stockLabel.attributedText = nil
    }
    
    private func commonInit() {
        setupSubViews()
        setupStackViewConstraints()
        setupBoder(cornerRadius: 10, borderWidth: 1.5, borderColor: UIColor.systemGray3.cgColor)
    }
    
    private func setupSubViews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productInformationStackView)
        
        [productNameLabel, priceLabel, stockLabel].forEach
        {
            productInformationStackView.addArrangedSubview($0)
        }
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate(
            [
                productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ])
        
        NSLayoutConstraint.activate(
            [
                productInformationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                productInformationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                productInformationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            ])
    }
    
    func setViewItems(_ product: ProductInformation) {
        OpenMarketManager.setupImage(key: product.thumbnail) { image in
            DispatchQueue.main.async { [weak self] in
                self?.productImageView.image = image
            }
        }
        
        productNameLabel.text = product.name
        priceLabel.attributedText = product.makePriceText()
        stockLabel.attributedText = product.makeStockText()
    }
}
