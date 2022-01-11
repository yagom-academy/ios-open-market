import UIKit

fileprivate extension UIConfigurationStateCustomKey {
    static let productItemKey = UIConfigurationStateCustomKey("productItemKey")
}

private extension UIConfigurationState {
    var prevItem: ProductDetail? { // TODO
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
        guard productItem != newProductItem else {
            return
        }
        
        productItem = newProductItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.prevItem = self.productItem
        return state
    }
    
    private func setupViewsIfNeeded() {
        guard stockLabelLayouts == nil else {
            return
        }
        
        [listContentView, stockLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        listContentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stockConstraints = [
            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: listContentView.centerYAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate([
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate(stockConstraints)
        
        stockLabelLayouts = stockConstraints
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        var content = defaultConfiguration().updated(for: state)
        
        content.textToSecondaryTextVerticalPadding = 10
        
        content.image = ImageLoader.loadImage(from: state.prevItem?.thumbnail)
        content.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)
        
        content.text = state.prevItem?.name
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        
        content.secondaryAttributedText = AttributedTextCreator.createPriceText(product: state.prevItem) ?? nil
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        
        listContentView.configuration = content
        
        stockLabel.attributedText = AttributedTextCreator.createStockText(product: state.prevItem) ?? nil
    }
}
