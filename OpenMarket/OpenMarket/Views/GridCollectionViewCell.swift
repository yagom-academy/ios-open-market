//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    private var discountPrice: Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productSalePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productPriceLabel,
                                                       productSalePriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel,
                                                       labelStackView,
                                                       productStockLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func setupProductImage(with productThumnail: String) {
        indicatorView.startAnimating()
        
        let cacheKey = NSString(string: productThumnail)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            productImageView.image = cachedImage
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
            return
        }
        
        if let imageURL = URL(string: productThumnail) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        self?.productImageView.image = image
                        self?.indicatorView.stopAnimating()
                        self?.indicatorView.isHidden = true
                    }
                }
            }
        }
    }
    
    func setupData(with productData: Product) {
        discountPrice = productData.discountedPrice
        
        productNameLabel.text = productData.name
        productPriceLabel.text = String(productData.price)
        productSalePriceLabel.text = String(productData.bargainPrice)
        productStockLabel.text = productData.stockDescription
        
        setupStockLabel()
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
    
    private func applyStrikeThroghtStyle(label: UILabel) {
        let attributeString = NSMutableAttributedString(string: label.text ?? "")
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
    }
}

// MARK: - Constraints
extension GridCollectionViewCell {
    func setupUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.gray.cgColor
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productStackView)
        contentView.addSubview(indicatorView)
        setupStackViewConstraints()
        setupIndicatorConstraints()
    }
    
    private func setupStockLabel() {
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
        applyStrikeThroghtStyle(label: productPriceLabel)
    }
    
    private func clearPriceLabel() {
        productSalePriceLabel.isHidden = false
        productPriceLabel.textColor = .gray
        productPriceLabel.attributedText = .none
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor, multiplier: 0.4),
            productImageView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor, multiplier: 0.4),
            
            productNameLabel.widthAnchor.constraint(
                equalTo: contentView.widthAnchor, multiplier: 0.9),
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.bottomAnchor.constraint(
                equalTo: productStackView.topAnchor, constant: -10),
            
            productStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -10),
            productStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupIndicatorConstraints() {
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: productImageView.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor)
        ])
    }
}

extension GridCollectionViewCell: ReuseIdentifierProtocol {
    
}
