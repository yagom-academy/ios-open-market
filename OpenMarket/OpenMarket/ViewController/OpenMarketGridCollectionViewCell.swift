//
//  OpenMarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/07.
//

import UIKit

class OpenMarketGridCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "OpenMarketGridCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    
    private lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textColor = .black
        label.text = "Macbook Pro 16 M1"
        return label
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "KRW 1600000"
        return label
    }()
    
    private lazy var itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "KRW 1500000"
        return label
    }()
    
    private lazy var itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textColor = .black
        label.text = "Stock : 200"
        return label
    }()
    
    private lazy var itemThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.image = UIImage(named: "macbook-pro-openmarket")
        return imageView
    }()
    
    private lazy var itemPricesStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemPriceLabel, itemDiscountedPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
}
extension OpenMarketGridCollectionViewCell {
    
    // MARK: - setup UI
    
    private func setUpUI() {
        self.contentView.addSubview(itemTitleLabel)
        self.contentView.addSubview(itemPricesStack)
        self.contentView.addSubview(itemStockLabel)
        self.contentView.addSubview(itemThumbnail)
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            itemThumbnail.heightAnchor.constraint(equalToConstant: self.contentView.bounds.height / 2),
            itemThumbnail.widthAnchor.constraint(equalToConstant: self.contentView.bounds.width * 0.8),
            itemThumbnail.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            itemThumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            
            itemTitleLabel.topAnchor.constraint(equalTo: itemThumbnail.bottomAnchor, constant: 5),
            itemTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            itemPricesStack.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 5),
            itemPricesStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemPricesStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            itemStockLabel.topAnchor.constraint(lessThanOrEqualTo: itemPricesStack.bottomAnchor, constant: 5),
            itemStockLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemStockLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            itemStockLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -2 )
        ])
    }
}
