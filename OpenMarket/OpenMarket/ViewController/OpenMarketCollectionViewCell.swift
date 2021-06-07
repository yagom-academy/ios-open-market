//
//  OpenMarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/02.
//

import UIKit

class OpenMarketCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "OpenMarketCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Mark: - Properties
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = itemThumbnail.center
        activityIndicator.color = UIColor.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    private lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "KRW 1600000"
        return label
    }()
    
    private lazy var itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "KRW 1500000"
        return label
    }()
    
    private lazy var itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
}
extension OpenMarketCollectionViewCell {
    
    // MARK: - setup UI
    
    private func setUpUI() {
        self.contentView.addSubview(activityIndicator)
        self.contentView.addSubview(itemTitleLabel)
        self.contentView.addSubview(itemPriceLabel)
        self.contentView.addSubview(itemDiscountedPriceLabel)
        self.contentView.addSubview(itemStockLabel)
        self.contentView.addSubview(itemThumbnail)
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            
            itemThumbnail.heightAnchor.constraint(greaterThanOrEqualToConstant: (contentView.bounds.height) - 10),
            itemThumbnail.widthAnchor.constraint(lessThanOrEqualToConstant: (self.contentView.frame.width) / 5),
            itemThumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            itemThumbnail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemThumbnail.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            
            itemTitleLabel.topAnchor.constraint(equalTo: self.itemThumbnail.topAnchor),
            itemTitleLabel.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            itemTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: itemPriceLabel.topAnchor, constant: -5 ),
            
            itemPriceLabel.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 5),
            itemPriceLabel.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            itemPriceLabel.bottomAnchor.constraint(equalTo: itemThumbnail.bottomAnchor),
            
            itemDiscountedPriceLabel.topAnchor.constraint(equalTo: itemPriceLabel.topAnchor),
            itemDiscountedPriceLabel.leadingAnchor.constraint(equalTo: itemPriceLabel.trailingAnchor, constant: 5),
            itemDiscountedPriceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            itemDiscountedPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -7),
            
            itemStockLabel.topAnchor.constraint(equalTo: itemTitleLabel.topAnchor),
            itemStockLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            itemStockLabel.leadingAnchor.constraint(equalTo: itemTitleLabel.trailingAnchor, constant: 5),
            itemStockLabel.bottomAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor)
            
        ])
        
    }
}
