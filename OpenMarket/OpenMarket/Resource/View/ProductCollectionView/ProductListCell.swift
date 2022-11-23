//
//  ProductListCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        
import UIKit

class ProductListCell: UICollectionViewCell {
    static let identifier = String(describing: ProductListCell.self)
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
        label.numberOfLines = 1
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
        label.textAlignment = .right
        label.textColor = .label
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    override func prepareForReuse() {
        thumbnailImageView.image = UIImage(systemName: "circle")
        task?.cancel()
        task = nil
        super.prepareForReuse()
    }
    
    func configureLayout() {
        [
            thumbnailImageView,
            stackView,
            stockLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupLayoutOfThumbnailImageView()
        setupLayoutOfStackView()
        setupLayoutOfStockLabel()
    }
    
    private func setupLayoutOfThumbnailImageView() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    private func setupLayoutOfStackView() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: stockLabel.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupLayoutOfStockLabel() {
        NSLayoutConstraint.activate([
            stockLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
}
