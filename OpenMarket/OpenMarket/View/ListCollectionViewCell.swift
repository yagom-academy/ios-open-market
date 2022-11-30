//  ListCollectionViewCell.swift
//  OpenMarket
//  Created by SummerCat on 2022/11/29.

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "listCell"
    var product: Product?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        productImageView.image = .none
        productNameLabel.text = .none
        priceLabel.attributedText = nil
        bargainPriceLabel.text = nil
        stockLabel.attributedText = nil
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    private let disclosureButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "chevron.forward")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    private func configureUI() {
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(priceStackView)
        contentView.addSubview(stockLabel)
        contentView.addSubview(disclosureButton)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 3),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productNameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.4),
            
            priceLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.4),
            bargainPriceLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.4),
            priceStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            priceStackView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            
            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: productNameLabel.trailingAnchor, constant: 8),
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stockLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.35),
            
            disclosureButton.leadingAnchor.constraint(equalTo: stockLabel.trailingAnchor, constant: 5),
            disclosureButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            disclosureButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            disclosureButton.widthAnchor.constraint(equalTo: disclosureButton.heightAnchor),
            disclosureButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3)
        ])
    }
    
    func updateContents(_ product: Product) {
        DispatchQueue.global().async {
            guard let url = URL(string: product.thumbnailURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                if product == self.product {
                    self.productImageView.image = image
                    self.productNameLabel.text = product.name
                    self.updatePriceLabel(product)
                    self.updateStockLabel(product)
                }
            }
        }
    }
    
    private func updatePriceLabel(_ product: Product) {
        let price: String = product.price.formatPrice(product.currency)
        let bargainPrice: String = product.bargainPrice.formatPrice(product.currency)
        
        priceLabel.attributedText = NSAttributedString(string: price)
        
        bargainPriceLabel.attributedText = NSAttributedString(string: bargainPrice)
        bargainPriceLabel.isHidden = product.price == product.bargainPrice

        if product.price != product.bargainPrice {
            priceLabel.attributedText = price.invalidatePrice()
        }
    }
    
    private func updateStockLabel(_ product: Product) {
        guard product.stock > 0 else {
            stockLabel.attributedText = StockStatus.soldOut.rawValue.markSoldOut()
            return
        }
        
        let remainingStock = StockStatus.remainingStock.rawValue + " : " + Double(product.stock).formatDecimal()
        
        stockLabel.attributedText = NSAttributedString(string: remainingStock)
    }
}


