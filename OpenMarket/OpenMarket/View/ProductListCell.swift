//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class ProductListCell: UICollectionViewListCell {
    
    private let productPriceLabel = UILabel()
    private func defaultProductConfiguration() -> UIListContentConfiguration {
        var config = UIListContentConfiguration.subtitleCell()
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return config
    }

    private lazy var productListContentView = UIListContentView(configuration: defaultProductConfiguration())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureLayout() {
        [self.productListContentView, self.productPriceLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.productListContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.productListContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.productListContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.productPriceLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.productPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.productListContentView.trailingAnchor),
            self.productPriceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        self.productListContentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func updateConfiguration(with product: Product) {
        var content = self.defaultProductConfiguration()
        content.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)
        content.image = UIImage(systemName: "timelapse")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = product.name
        content.textProperties.font = .boldSystemFont(ofSize: 18)
        content.secondaryTextProperties.color = .gray
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        content.secondaryAttributedText = product.attributedPriceString
        
        let networkProvider = NetworkAPIProvider()
        networkProvider.fetchImage(url: product.thumbnail) { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async { [weak self] in
                    content.image = UIImage(systemName: "xmark.seal.fill")
                    self?.productListContentView.configuration = content
                }
                return
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    content.image = image
                    self?.productListContentView.configuration = content
                }
            }
        }
        
        self.productListContentView.configuration = content
        
        self.productPriceLabel.font = .preferredFont(forTextStyle: .subheadline)
        self.productPriceLabel.textColor = .gray
        self.productPriceLabel.attributedText = product.stock == 0 ? "품절".foregroundColor(.orange) : "잔여수량: \(product.stock)".attributed
    }
}
