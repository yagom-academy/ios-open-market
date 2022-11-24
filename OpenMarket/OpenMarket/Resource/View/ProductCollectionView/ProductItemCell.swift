//
//  ProductItemCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import UIKit

class ProductItemCell: UICollectionViewCell {
    static let identifier = String(describing: ProductItemCell.self)
    var task: URLSessionDataTask? {
        didSet {
            if task != nil {
                task?.resume()
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        
        label.textColor = .label
        
        
        return label
    }()
    
    override func prepareForReuse() {
        thumbnailImageView.image = UIImage(systemName: "circle")
        task?.cancel()
        task = nil
        super.prepareForReuse()
    }
    
    func configureLayout(index: Int) {
        [
            thumbnailImageView,
            titleLabel,
            subTitleLabel,
            stockLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if index == 0 {
            setupLayoutListCell()
        } else {
            setupLayoutGridCell()
        }
        
    }
    
    private func setupLayoutListCell() {
        func setupLayoutOfThumbnailImageView() {
            NSLayoutConstraint.activate([
                thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                thumbnailImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor)
            ])
        }
        
        func setupLayoutOfTitleLabel() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: stockLabel.leadingAnchor)
            ])
        }
        
        func setupLayoutOfSubTitleLabel() {
            NSLayoutConstraint.activate([
                subTitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
                subTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
                subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
            ])
        }
        
        func setupLayoutOfStockLabel() {
            NSLayoutConstraint.activate([
                stockLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
                stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                stockLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                stockLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
                stockLabel.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor, multiplier: 0.3)
            ])
        }
        
        setupLayoutOfThumbnailImageView()
        setupLayoutOfTitleLabel()
        setupLayoutOfSubTitleLabel()
        setupLayoutOfStockLabel()
    }
    
    private func setupLayoutGridCell(){
        func setupLayoutOfThumbnailImageView() {
            NSLayoutConstraint.activate([
                thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                thumbnailImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor)
            ])
        }
        
        func setupLayoutOfTitleLabel() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
        
        func setupLayoutOfSubTitleLabel() {
            NSLayoutConstraint.activate([
                subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
        
        func setupLayoutOfStockLabel() {
            NSLayoutConstraint.activate([
                stockLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor),
                stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        setupLayoutOfThumbnailImageView()
        setupLayoutOfTitleLabel()
        setupLayoutOfSubTitleLabel()
        setupLayoutOfStockLabel()
    }
}
