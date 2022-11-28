//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class ProductListCell: UICollectionViewListCell {
    
    private var productData: Product?
    private let productPriceLabel = UILabel()
    private var customViewConstraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint)?
    
    func update(with newProduct: Product) {
        guard self.productData != newProduct else { return }
        self.productData = newProduct
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.productData = self.productData
        return state
    }
    
    private func defaultProductConfiguration() -> UIListContentConfiguration {
        var config = UIListContentConfiguration.subtitleCell()
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return config
    }
    
    private lazy var productListContentView = UIListContentView(configuration: defaultProductConfiguration())
}

private extension UIConfigurationStateCustomKey {
    
    static let product = UIConfigurationStateCustomKey("product")
}

private extension UICellConfigurationState {
    
    var productData: Product? {
        set { self[.product] = newValue }
        get { return self[.product] as? Product }
    }
}

extension ProductListCell {
    
    func setupViewsIfNeeded() {
        guard self.customViewConstraints == nil else {
            return
        }
        
        [self.productListContentView, self.productPriceLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints = (leading:
                            self.productPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.productListContentView.trailingAnchor),
                           trailing:
                            self.productPriceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor))
        
        NSLayoutConstraint.activate([
            self.productListContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.productListContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.productListContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.productPriceLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            constraints.leading,
            constraints.trailing
        ])
        
        self.productListContentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        self.customViewConstraints = constraints
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        guard let productData = state.productData else { return }
        
        var content = defaultProductConfiguration().updated(for: state)
        content.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)
        content.image = UIImage(systemName: "timelapse")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = productData.name
        content.textProperties.font = .boldSystemFont(ofSize: 18)
        content.secondaryTextProperties.color = .gray
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        content.secondaryAttributedText = productData.attributedPriceString
        
        let networkProvider = NetworkAPIProvider()
        networkProvider.fetchImage(url: productData.thumbnail) { result in
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
        self.productPriceLabel.attributedText = productData.stock == 0 ? "품절".foregroundColor(.orange) : "잔여수량: \(productData.stock)".attributed
    }
}
