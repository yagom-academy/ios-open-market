//  GridCollectionViewCell.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/25.

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "gridCell"
    
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
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        stockLabel.attributedText = nil
        stockLabel.text = .none
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
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private func configureUI() {
        contentView.addSubview(stackView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        
        stackView.addArrangedSubview(productImageView)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(priceStackView)
        stackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.95),
            productImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            productNameLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            stockLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1)
        ])
    }
    
    func updateContents(_ product: Product) {
        DispatchQueue.global().async {
            guard let url = URL(string: product.thumbnailURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.productImageView.image = image
                self.productNameLabel.text = product.name
                self.updatePriceLabel(product)
                self.updateStockLabel(product)
            }
        }
    }
    
    private func updatePriceLabel(_ product: Product) {
        let price: String = Formatter.format(product.price, product.currency)
        let bargainPrice: String = Formatter.format(product.bargainPrice, product.currency)
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
        
        let remainingStock = StockStatus.remainingStock.rawValue + " : \(product.stock)"
        
        stockLabel.attributedText = NSAttributedString(string: remainingStock)
    }
}


