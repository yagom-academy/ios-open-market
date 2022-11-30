//
//  ProductListItemCell.swift
//  OpenMarket
//
//  Created by mini on 2022/11/28.
//

import UIKit

final class ProductListItemCell: UICollectionViewCell, ProductItemCellContent {
    static let identifier = String(describing: ProductListItemCell.self)
    
    var task: URLSessionDataTask?
    
    var activityIndicator = UIActivityIndicatorView()
    
    var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.1
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task?.cancel()
        task = nil
        thumbnailImageView.image = nil
        activityIndicator.startAnimating()
    }
    
    func configureLayout() {
        [
            thumbnailImageView,
            titleLabel,
            subTitleLabel,
            stockLabel,
            activityIndicator
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor, constant: -8),
            
            subTitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stockLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    func configureStyle() {
        titleLabel.textAlignment = .left
        subTitleLabel.textAlignment = .left
        stockLabel.textAlignment = .right
        
        layer.cornerRadius = 0
        layer.borderWidth = 0
        layer.borderColor = nil
    }
}
