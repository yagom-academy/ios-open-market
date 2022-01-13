import UIKit

fileprivate extension UIConfigurationStateCustomKey {
    static let productItemKey = UIConfigurationStateCustomKey("productItemKey")
}

private extension UIConfigurationState {
    var product: ProductDetail? {
        get {
            return self[.productItemKey] as? ProductDetail
        }
        set {
            self[.productItemKey] = newValue
        }
    }
}

class ProductListLayoutCell: UICollectionViewListCell {
    private var productItem: ProductDetail?
    private lazy var listContentView = UIListContentView(configuration: defaultConfiguration())
    private var stockLabel = UILabel()
    private var stockLabelLayouts: [NSLayoutConstraint]?
    
    private func defaultConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    func updateWithProduct(from newProductItem: ProductDetail) {
        if productItem == newProductItem {
            return
        }
        
        productItem = newProductItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.product = self.productItem
        return state
    }
    
    private func setupViewsIfNeeded() {
        guard stockLabelLayouts == nil else {
            return
        }
        
        [listContentView, stockLabel].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        listContentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stockConstraints = [
            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: listContentView.centerYAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate([
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate(stockConstraints)
        
        stockLabelLayouts = stockConstraints
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        var content = defaultConfiguration().updated(for: state)
            
        content.textToSecondaryTextVerticalPadding = 10
        content.imageToTextPadding = 10
        
        content.image = ImageLoader.loadImage(from: state.product?.thumbnail)
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        
        content.text = state.product?.name
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        
        content.secondaryAttributedText = AttributedTextCreator.createPriceText(product: state.product) ?? nil
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        
        listContentView.configuration = content
        
        stockLabel.attributedText = AttributedTextCreator.createStockText(product: state.product) ?? nil
    }
}
