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
        imageView.contentMode = .scaleAspectFill
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
        
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
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
            configureGridItemStyle()
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
                thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                thumbnailImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            ])
        }
        
        func setupLayoutOfTitleLabel() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(lessThanOrEqualTo: thumbnailImageView.bottomAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
        
        func setupLayoutOfSubTitleLabel() {
            NSLayoutConstraint.activate([
                subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                subTitleLabel.bottomAnchor.constraint(equalTo: stockLabel.topAnchor)
            ])
            subTitleLabel.setContentHuggingPriority(.init(1), for: .vertical)
        }
        
        func setupLayoutOfStockLabel() {
            NSLayoutConstraint.activate([
                stockLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                stockLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                stockLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        }
        
        setupLayoutOfThumbnailImageView()
        setupLayoutOfTitleLabel()
        setupLayoutOfSubTitleLabel()
        setupLayoutOfStockLabel()
        
        
    }
    
    private func configureGridItemStyle() {
        [titleLabel, subTitleLabel, stockLabel].forEach {
            $0.textAlignment = .center
        }
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        
        subTitleLabel.textColor = .lightGray
        subTitleLabel.font = .preferredFont(forTextStyle: .caption1)
        
        stockLabel.textColor = .lightGray
        stockLabel.font = .preferredFont(forTextStyle: .caption1)
        
        thumbnailImageView.layer.cornerRadius = 20
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
        thumbnailImageView.layer.borderWidth = 0.1
        
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
    }
}
