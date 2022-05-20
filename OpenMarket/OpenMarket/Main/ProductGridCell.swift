//
//  ProductGridCell.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/12.
//

import UIKit

final class ProductGridCell: UICollectionViewCell, ProductCell {
    private var imageDownloadTask: URLSessionDataTask?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productStackView, priceStackView, quantityLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, bargainPriceLabel])
        stackView.setContentHuggingPriority(.lowest, for: .vertical)
        stackView.axis = .vertical
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .center
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        layer.cornerRadius = 10
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.systemGray3.cgColor
    }
}

// MARK: - ProductGridCell Method

extension ProductGridCell {
    private func configureLayout() {
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.7),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = UIImage(systemName: "photo.on.rectangle.angled")
        nameLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        quantityLabel.textColor = .label
        quantityLabel.text = nil
        
        imageDownloadTask?.suspend()
        imageDownloadTask?.cancel()
    }
    
    func configure(data: Product) {
        nameLabel.text = data.name
        
        priceLabel.text = data.price?.priceFormat(currency: data.currency?.rawValue)
        bargainPriceLabel.text = data.bargainPrice?.priceFormat(currency: data.currency?.rawValue)
        
        if data.price == data.bargainPrice {
            bargainPriceLabel.isHidden = true
            priceLabel.textColor = .systemGray3
        } else {
            bargainPriceLabel.isHidden = false
            priceLabel.textColor = .systemRed
            priceLabel.addStrikethrough()
        }
        
        quantityLabel.textColor = data.stock == 0 ? .systemOrange : .systemGray3
        quantityLabel.text = data.stock == 0 ? "품절" : "잔여수량: \(data.stock ?? 0)"
        
        downloadImage(imageURL: data.thumbnail)
    }
    
    private func downloadImage(imageURL: String?) {
       imageDownloadTask = ImageManager.shared.downloadImage(urlString: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.thumbnailImageView.image = image
                }
            case .failure(_):
                break
            }
        }
    }
}
