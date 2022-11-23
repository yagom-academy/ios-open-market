//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

class ProductListCell: UICollectionViewListCell {
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
            productPriceLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
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
        var priceText = "\(productData.currency) \(productData.price) "
        var attributedStr = NSMutableAttributedString(string: priceText)
        
        content.image = urlToImage(productData.thumbnail)
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = productData.name
        content.textProperties.font = .preferredFont(forTextStyle: .body)
        
        if productData.bargainPrice != productData.price {
            priceText += "\(productData.currency) \(productData.bargainPrice)"
            attributedStr = NSMutableAttributedString(string: priceText)
            attributedStr.addAttributes([.strikethroughStyle: 1, .foregroundColor: UIColor.systemRed], range: (priceText as NSString).range(of: "\(productData.currency) \(productData.price)"))
        }
        content.secondaryAttributedText = attributedStr
        
        productListContentView.configuration = content
        
        productPriceLabel.font = .preferredFont(forTextStyle: .subheadline)
        productPriceLabel.textColor = .gray
        productPriceLabel.text = "잔여수량: \(productData.stock)"
    }
    
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}

fileprivate extension UIConfigurationStateCustomKey {
    static let product = UIConfigurationStateCustomKey("product")
}

private extension UICellConfigurationState {
    var productData: Product? {
        set { self[.product] = newValue }
        get { return self[.product] as? Product }
    }
}


