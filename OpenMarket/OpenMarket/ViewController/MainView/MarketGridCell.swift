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
    
    func configureCell(page: Page,
                       completionHandler: @escaping (() -> Void) -> Void) {
        setupLayout()
        nameLabel.text = page.name
        productImage.image = UIImage(named: "loading")
        generatePriceLabelContent(page: page)
        generateStockLabelContent(page: page)
        fetchImage(page: page, completionHandler: completionHandler)
    }
    
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
    
    private func generatePriceLabelContent(page: Page) {
        if page.bargainPrice > 0  {
            priceLabel.attributedText = NSMutableAttributedString()
                .strikethrough(string: "\(page.currency.rawValue) \(page.price)")
                .normal(string: "\n\(page.currency.rawValue) \(page.bargainPrice)")
        } else {
            priceLabel.attributedText = NSMutableAttributedString()
                .normal(string: "\(page.currency.rawValue) \(page.price)")
        }
    }
    
    private func generateStockLabelContent(page: Page) {
        if page.stock == 0 {
            stockLabel.attributedText = NSMutableAttributedString()
                .orangeColor(string: "품절")
        } else {
            stockLabel.attributedText = NSMutableAttributedString()
                .normal(string: "잔여수량: \(page.stock)")
        }
    }
    
    private func fetchImage(page: Page,
                            completionHandler: @escaping (() -> Void) -> Void) {
        let thumbnailUrl = page.thumbnail
        let cacheKey = NSString(string: thumbnailUrl)
        let session = MarketURLSessionProvider()
        
        if let cachedImage = ImageCacheProvider.shared.object(forKey: cacheKey) {
            productImage.image = cachedImage
        } else {
            guard let imageUrl = URL(string: thumbnailUrl) else {
                print(NetworkError.generateUrlFailError.localizedDescription)
                return
            }
            
            let request = URLRequest(url: imageUrl)
            
            session.fetchData(request: request) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: data) else {
                            print(NetworkError.generateImageDataFailError.localizedDescription)
                            return
                        }
                        
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
