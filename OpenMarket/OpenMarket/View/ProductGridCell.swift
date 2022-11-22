//
//  ProductGridCell.swift
//  OpenMarket
//
//  Created by Ayaan on 2022/11/22.
//

import UIKit

final class ProductGridCell: UICollectionViewCell {
    private let thumbnailImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title2,
                                          compatibleWith: UITraitCollection.init(preferredContentSizeCategory: .large))
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let stockLabel: StockLabel = StockLabel()
    private let priceLabel: PriceLabel = PriceLabel()
    private let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var product: Product? {
        didSet {
            setupDataIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
        setupViewsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithProduct(_ product: Product) {
        self.product = product
    }
    
    private func setupViewsIfNeeded() {
        stackView.addArrangedSubview(thumbnailImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.47),
            nameLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.14),
            priceLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.18),
            stockLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.12)
        ])
    }
    
    private func setupDataIfNeeded() {
        guard let product = product else {
            return
        }
        DispatchQueue.global().async {
            if let thumbnailURL = URL(string: product.thumbnail),
               let thumbnailData = try? Data(contentsOf: thumbnailURL) {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(data: thumbnailData)
                }
            }
        }
        nameLabel.text = product.name
        stockLabel.stock = product.stock
        priceLabel.setPrice(product.price,
                            bargainPrice: product.bargainPrice,
                            currency: product.currency)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        nameLabel.text = ""
        stockLabel.stock = 0
        priceLabel.setPrice(0,
                            bargainPrice: 0,
                            currency: Currency.krw)
    }
}
