//
//  OpenMarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/07.
//

import UIKit

class OpenMarketGridCollectionViewCell: UICollectionViewCell, CellDataUpdatable {
    var imageDataTask: URLSessionDataTask?
    static let identifier: String = "OpenMarketGridCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    
    lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    lazy var itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    lazy var itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    lazy var itemThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.image = UIImage(named: "loadingPic")
        return imageView
    }()
    
    lazy var itemPricesStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemPriceLabel, itemDiscountedPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
}
extension OpenMarketGridCollectionViewCell {
    
    // MARK: - setup UI Constraints
    
    private func setUpUIConstraints() {
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
            
            itemStockLabel.topAnchor.constraint(greaterThanOrEqualTo: itemPricesStack.bottomAnchor, constant: 5),
            itemStockLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemStockLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            itemStockLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5 )
        ])
    }
}
extension OpenMarketGridCollectionViewCell {
    
    // MARK: - configure cell
    
    func configure(_ openMarketItems: [OpenMarketItem], indexPath: Int) {
        for _ in openMarketItems {
            itemTitleLabel.text = openMarketItems[indexPath].title
            itemPriceLabel.text = "\(openMarketItems[indexPath].currency) \(openMarketItems[indexPath].price)"
            itemStockLabel.text = String(openMarketItems[indexPath].stock)
            
            configureDiscountedPriceLabel(openMarketItems, indexPath: indexPath)
            configureStockLabel(openMarketItems, indexPath: indexPath)
            configureThumbnail(openMarketItems, indexPath: indexPath)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDataTask?.cancel()
        self.itemThumbnail.image = UIImage(named: "loadingPic")
        self.itemTitleLabel.text = nil
        self.itemPriceLabel.text = nil
        self.itemStockLabel.text = nil
        self.itemDiscountedPriceLabel.text = nil
    }
}
