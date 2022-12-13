//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    private var discountPrice: Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let productSalePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private lazy var priceLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productPriceLabel,
                                                       productSalePriceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stockButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productStockLabel,
                                                       detailButton])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var topLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel,
                                                       stockButtonStackView])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func uploadImage(_ image: UIImage) {
        productImageView.image = image
        indicatorView.stopAnimating()
    }
    
    func setupData(with productData: Product) {
        discountPrice = productData.discountedPrice
        
        productNameLabel.text = productData.name
        productPriceLabel.text = String(productData.currencyPrice)
        productSalePriceLabel.text = String(productData.currencyBargainPrice)
        productStockLabel.text = productData.stockDescription
        
        setupStockLabelText()
        setupPriceLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearPriceLabel()
        
        productImageView.image = nil
        productNameLabel.text = nil
        productPriceLabel.text = nil
        productSalePriceLabel.text = nil
        productStockLabel.text = nil
    }
}

// MARK: - Constraints
extension ListCollectionViewCell {
    private func setupUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.gray.cgColor
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(indicatorView)
        contentView.addSubview(productImageView)
        contentView.addSubview(topLabelStackView)
        contentView.addSubview(priceLabelStackView)
        
        setupConstraints()
        setupIndicatorViewConstraints()
    }
    
    private func setupStockLabelText() {
        if productStockLabel.text == "품절" {
            productStockLabel.textColor = .systemOrange
        } else {
            productStockLabel.textColor = .gray
        }
    }
    
    private func setupPriceLabel() {
        if discountPrice == Double.zero {
            productSalePriceLabel.isHidden = true
        } else {
            changePriceLabel()
        }
    }
    
    private func changePriceLabel() {
        productPriceLabel.textColor = .red
        productPriceLabel.applyStrikeThroughStyle()
    }
    
    private func clearPriceLabel() {
        productSalePriceLabel.isHidden = false
        productPriceLabel.textColor = .gray
        productPriceLabel.attributedText = .none
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                    multiplier: 0.2),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                     constant: -5),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: 10),
            
            topLabelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,
                                                       constant: -10),
            topLabelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor,
                                                       constant: 10),
            topLabelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                        constant: -10),
            
            priceLabelStackView.topAnchor.constraint(equalTo: topLabelStackView.bottomAnchor,
                                                     constant: 2),
            priceLabelStackView.leadingAnchor.constraint(equalTo: topLabelStackView.leadingAnchor)
        ])
    }
    
    private func setupIndicatorViewConstraints() {
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: productImageView.topAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
        ])
    }
}

extension ListCollectionViewCell: ReuseIdentifierProtocol {
    
}
