//
//  MarketGridCell.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/23.
//

import UIKit

final class MarketGridCell: UICollectionViewCell {
    private var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.setContentHuggingPriority(.init(rawValue: 10), for: .vertical)
        label.numberOfLines = 0
        
        return label
    }()
    
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        
        return label
    }()
    
    private var productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private func setupLayout() {
        [productImage, nameLabel, priceLabel, stockLabel].forEach {
            productStackView.addArrangedSubview($0)
        }
        
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 25
        contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                  constant: 10),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                     constant: -10),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -10)
        ])
    }
    
    func configureCell(page: Page,
                       completionHandler: @escaping (() -> Void) -> Void) {
        setupLayout()
        
        let thumbnailUrl = page.thumbnail
        let cacheKey = NSString(string: thumbnailUrl)
        let session = MarketURLSessionProvider()
        
        productImage.image = UIImage(named: "loading")
        
        if page.bargainPrice > 0  {
            priceLabel.attributedText = NSMutableAttributedString()
                .strikethrough(string: "\(page.currency.rawValue) \(page.price)")
                .normal(string: "\n\(page.currency.rawValue) \(page.bargainPrice)")
        } else {
            priceLabel.attributedText = NSMutableAttributedString()
                .normal(string: "\(page.currency.rawValue) \(page.price)")
        }
        
        nameLabel.text = page.name
        
        if page.stock == 0 {
            stockLabel.attributedText = NSMutableAttributedString()
                .orangeColor(string: "품절")
        } else {
            stockLabel.attributedText = NSMutableAttributedString()
                .normal(string: "잔여수량: \(page.stock)")
        }
        
        if let cachedImage = ImageCacheProvider.shared.object(forKey: cacheKey) {
            productImage.image = cachedImage
        } else {
            session.fetchImage(url: thumbnailUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        ImageCacheProvider.shared.setObject(image, forKey: cacheKey)
                        let updateImage = {
                            self.productImage.image = image
                        }
                        completionHandler(updateImage)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
