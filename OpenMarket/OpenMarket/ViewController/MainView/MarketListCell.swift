//
//  MarketListCell.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

final class MarketListCell: UICollectionViewListCell {
    private var pageListContentView = UIListContentView(configuration: .subtitleCell())
    
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    private var disclosureIndicatorView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
        imageView.bounds.size = CGSize(width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var stockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .top
        
        return stackView
    }()
    
    func configureCell(page: Page,
                       completionHandler: @escaping (() -> Void) -> Void) {
        setupLayout()
        
        var content = UIListContentConfiguration.subtitleCell()
        
        content.image = UIImage(named: "loading")
        content.imageProperties.reservedLayoutSize = CGSize(width: 70, height: 70)
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        content.imageProperties.cornerRadius = 10
        
        content.text = page.name
        content.textProperties.font = .preferredFont(forTextStyle: .title3)
        
        content.textToSecondaryTextVerticalPadding = 5
        content.secondaryTextProperties.color = .systemGray
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryAttributedText = generatePriceLabelContent(page: page)
        
        stockLabel.attributedText = generateStockLabelContent(page: page)
        
        fetchImage(page: page, content: content, completionHandler: completionHandler)
    }
    
    private func setupLayout() {
        [stockLabel, disclosureIndicatorView].forEach {
            stockStackView.addArrangedSubview($0)
        }
        
        [pageListContentView, stockStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            pageListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pageListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pageListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageListContentView.trailingAnchor.constraint(equalTo: stockStackView.leadingAnchor,
                                                          constant: -10),
            pageListContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pageListContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                       multiplier: 0.7),
            
            stockStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 10),
            stockStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -10)
        ])
    }
    
    private func generatePriceLabelContent(page: Page) -> NSAttributedString {
        if page.bargainPrice > 0  {
            return NSMutableAttributedString()
                .strikethrough(string: "\(page.currency.rawValue) \(page.price)")
                .normal(string: "\n\(page.currency.rawValue) \(page.bargainPrice)")
        } else {
            return NSMutableAttributedString()
                .normal(string: "\(page.currency.rawValue) \(page.price)")
        }
    }
    
    private func generateStockLabelContent(page: Page) -> NSAttributedString {
        if page.stock == 0 {
            return NSMutableAttributedString().orangeColor(string: "품절")
        } else {
            return NSMutableAttributedString().normal(string: "잔여수량:\n\(page.stock)")
        }
    }
    
    private func fetchImage(page: Page,
                            content: UIListContentConfiguration,
                            completionHandler: @escaping (() -> Void) -> Void) {
        let thumbnailUrl = page.thumbnail
        let cacheKey = NSString(string: thumbnailUrl)
        let session = MarketURLSessionProvider()
        var content = content
        
        if let cachedImage = ImageCacheProvider.shared.object(forKey: cacheKey) {
            content.image = cachedImage
        } else {
            guard let imageUrl = URL(string: thumbnailUrl) else {
                print(NetworkError.generateUrlFailError.localizedDescription)
                return
            }
            
            session.fetchData(request: URLRequest(url: imageUrl)) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: data) else {
                            print(NetworkError.generateImageDataFailError.localizedDescription)
                            return
                        }
                        
                        ImageCacheProvider.shared.setObject(image, forKey: cacheKey)
                        content.image = image
                        
                        let updateConfiguration = {
                            self.pageListContentView.configuration = content
                        }
                        
                        completionHandler(updateConfiguration)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        pageListContentView.configuration = content
    }
}
