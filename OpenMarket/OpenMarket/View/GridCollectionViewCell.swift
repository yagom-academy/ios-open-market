//  GridCollectionViewCell.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/25.

import UIKit

// lazy ㄴㄴ! -> addSubview 하는것들 이동
//
class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "gridCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("reuse!!")
        
        productImageView.image = .none
        productNameLabel.text = .none
        priceLabel.text = .none
        bargainPriceLabel.text = .none
        priceLabel.attributedText = .none
        stockLabel.text = .none
    }
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
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
        priceLabel.text = product.currency.rawValue + " \(price)"
        bargainPriceLabel.text = product.currency.rawValue + " \(bargainPrice)"
        
        if product.price == product.bargainPrice {
            print("equal", product.name, product.price, product.bargainPrice)
            bargainPriceLabel.text = ""
        } else {
            print("else", product.name, product.price, product.bargainPrice)
            priceLabel.attributedText = priceLabel.text?.invalidatePrice()
        }
    }
    
    private func updateStockLabel(_ product: Product) {
        guard product.stock > 0 else {
            stockLabel.text = "품절"
            stockLabel.attributedText = stockLabel.text?.markSoldOut()
            return
        }
        
        stockLabel.text = "잔여수량 : \(product.stock)"
    }
}
