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
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var roundedBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.numberOfLines = 1
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
        label.textColor = .black
        label.text = "수량 : 200"
        return label
    }()
    
    private lazy var itemThumbnail: UIImageView = {
        let imageHeight = (roundedBackgroundView.bounds.height) * 0.8
        let imageWidth = (roundedBackgroundView.bounds.width / 20) * 0.9
        let imageView = UIImageView(frame: CGRect(origin: roundedBackgroundView.bounds.origin, size: CGSize(width: imageWidth, height: imageHeight)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
//        imageView.sizeThatFits(CGSize(width: imageWidth, height: imageHeight))
        imageView.image = .strokedCheckmark
        return imageView
    }()
}
extension OpenMarketCollectionViewCell {
    
    // MARK: - setup UI
    
    private func setUpUI() {
        self.contentView.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubview(activityIndicator)
        roundedBackgroundView.addSubview(itemTitleLabel)
        roundedBackgroundView.addSubview(itemPriceLabel)
        roundedBackgroundView.addSubview(itemDiscountedPriceLabel)
        roundedBackgroundView.addSubview(itemStockLabel)
        roundedBackgroundView.addSubview(itemThumbnail)
        
        NSLayoutConstraint.activate([
            roundedBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            roundedBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            roundedBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            itemThumbnail.topAnchor.constraint(equalTo: roundedBackgroundView.topAnchor, constant: 5),
            itemThumbnail.leadingAnchor.constraint(equalTo: roundedBackgroundView.leadingAnchor, constant: 5),
            itemThumbnail.bottomAnchor.constraint(equalTo: roundedBackgroundView.bottomAnchor, constant: 5),
            
            itemTitleLabel.topAnchor.constraint(equalTo: itemThumbnail.topAnchor),
            itemTitleLabel.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            
            itemPriceLabel.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 5),
            itemPriceLabel.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            itemPriceLabel.bottomAnchor.constraint(equalTo: itemThumbnail.bottomAnchor),
            
            itemDiscountedPriceLabel.topAnchor.constraint(equalTo: itemPriceLabel.topAnchor),
            itemDiscountedPriceLabel.leadingAnchor.constraint(equalTo: itemPriceLabel.trailingAnchor, constant: 5),
            itemDiscountedPriceLabel.bottomAnchor.constraint(equalTo: roundedBackgroundView.bottomAnchor, constant: 5),
            itemDiscountedPriceLabel.trailingAnchor.constraint(greaterThanOrEqualTo: roundedBackgroundView.trailingAnchor, constant: 5),
            
            itemStockLabel.topAnchor.constraint(equalTo: itemTitleLabel.topAnchor),
            itemStockLabel.trailingAnchor.constraint(equalTo: roundedBackgroundView.trailingAnchor, constant: 5),
            itemStockLabel.leadingAnchor.constraint(equalTo: itemTitleLabel.trailingAnchor, constant: 5)
            
        ])
        
    }
}
