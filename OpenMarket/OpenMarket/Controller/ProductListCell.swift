//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class ProductListCell: UICollectionViewListCell {
    
    private var productData: Product?
    private let productPriceLabel = UILabel()
    private var customViewConstraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint)?
    
    func update(with newProduct: Product) {
        guard productData != newProduct else { return }
        productData = newProduct
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
        guard customViewConstraints == nil else {
            return
        }
        
        [productListContentView, productPriceLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints = (leading:
                            productPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: productListContentView.trailingAnchor),
                           trailing:
                            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        NSLayoutConstraint.activate([
            productListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            constraints.leading,
            constraints.trailing
        ])
        
        productListContentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        customViewConstraints = constraints
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
        
        productListContentView.configuration = content
        
        productPriceLabel.font = .preferredFont(forTextStyle: .subheadline)
        productPriceLabel.textColor = .gray
        productPriceLabel.attributedText = productData.stock == 0 ? "품절".foregroundColor(.orange) : "잔여수량: \(productData.stock)".attributed
    }
}
