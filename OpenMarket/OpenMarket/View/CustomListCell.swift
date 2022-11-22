//
//  CustomListCell.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/22.
//

import UIKit

final class ProductListCell: UICollectionViewListCell {
    private let thumbnailImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle,
                                          compatibleWith: UITraitCollection.init(preferredContentSizeCategory: .large))
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let stockLabel: StockLabel = StockLabel()
    private let priceLabel: PriceLabel = PriceLabel()
    
    private var product: Product? {
        didSet {
            setupDataIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithProduct(_ product: Product) {
        self.product = product
    }
    
    private func setupViewsIfNeeded() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(priceLabel)
        
        let spacing: CGFloat = 10
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            thumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -spacing),
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor),
            nameLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: spacing),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: stockLabel.leadingAnchor, constant: spacing),
            stockLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            stockLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: spacing),
            priceLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: spacing),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -spacing),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -spacing)
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
