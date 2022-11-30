//
//  ProductGridItemCell.swift
//  OpenMarket
//
//  Created by mini on 2022/11/28.
//

import UIKit

final class ProductGridItemCell: UICollectionViewCell, ProductItemCellContent {
    static let identifier = String(describing: ProductGridItemCell.self)

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
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            thumbnailImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            
            activityIndicator.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: stockLabel.topAnchor),
            
            stockLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        subTitleLabel.setContentHuggingPriority(.init(1), for: .vertical)
    }
    
    func configureStyle() {
        titleLabel.textAlignment = .center
        subTitleLabel.textAlignment = .center
        stockLabel.textAlignment = .center
        
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
    }
}
