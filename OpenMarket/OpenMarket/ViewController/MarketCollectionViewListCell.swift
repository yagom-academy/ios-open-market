//
//  MarketCollectionViewListCell.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

class MarketCollectionViewListCell: UICollectionViewListCell {
    var pageListContentView = UIListContentView(configuration: .subtitleCell())
    
    var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    var disclosureIndicatorView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
        imageView.bounds.size = CGSize(width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var stockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .top
        return stackView
    }()
    
    func configureCell(page: Page,
                       collectionView: UICollectionView,
                       indexPath: IndexPath,
                       cell: MarketCollectionViewListCell) {
        setupViewsIfNeeded()
        
        var content = UIListContentConfiguration.subtitleCell()
        let thumbnailUrl = page.thumbnail
        let cacheKey = NSString(string: thumbnailUrl)
        let session = MarketURLSessionProvider()
        
        content.image = UIImage(named: "loading")
        content.imageProperties.reservedLayoutSize = CGSize(width: 70, height: 70)
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        content.imageProperties.cornerRadius = 10
        content.text = page.name
        content.textProperties.font = .preferredFont(forTextStyle: .title3)
        content.textToSecondaryTextVerticalPadding = 5
        content.secondaryTextProperties.color = .systemGray
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        
        if page.bargainPrice > 0  {
            content.secondaryAttributedText = NSMutableAttributedString()
                .strikethrough(string: "\(page.currency.rawValue) \(page.price)")
                .normal(string: "\n\(page.currency.rawValue) \(page.bargainPrice)")
        } else {
            content.secondaryAttributedText = NSMutableAttributedString()
                .normal(string: "\(page.currency.rawValue) \(page.price)")
        }
        
        if page.stock == 0 {
            stockLabel.attributedText = NSMutableAttributedString()
                .orangeColor(string: "품절")
        } else {
            stockLabel.attributedText = NSMutableAttributedString()
                .normal(string: "잔여수량:\n\(page.stock)")
        }
        
        if let cachedImage = ImageCacheProvider.shared.object(forKey: cacheKey) {
            content.image = cachedImage
        } else {
            session.fetchImage(url: thumbnailUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        ImageCacheProvider.shared.setObject(image, forKey: cacheKey)
                        content.image = image
                        guard indexPath == collectionView.indexPath(for: cell) else { return }
                        self.pageListContentView.configuration = content
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        pageListContentView.configuration = content
    }
    
    func setupViewsIfNeeded() {
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
            pageListContentView.trailingAnchor.constraint(equalTo: stockStackView.leadingAnchor,constant: -10),
            pageListContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pageListContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            stockStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stockStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
