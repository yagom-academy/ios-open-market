//
//  GridCell.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/18.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let accessoryImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 8).isActive = true
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let nameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let accessoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        
        return stackView
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
        contentView.addSubview(nameAndPriceStackView)
        contentView.addSubview(accessoryStackView)
        
        [productNameLabel, priceLabel].forEach
        {
            nameAndPriceStackView.addArrangedSubview($0)
        }
        
        [stockLabel, accessoryImageButton].forEach
        {
            accessoryStackView.addArrangedSubview($0)
        }
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate(
            [
                productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate(
            [
                nameAndPriceStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
                nameAndPriceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                nameAndPriceStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
        
        NSLayoutConstraint.activate(
            [
                accessoryStackView.leadingAnchor.constraint(equalTo: nameAndPriceStackView.trailingAnchor),
                accessoryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                accessoryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                accessoryStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
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
