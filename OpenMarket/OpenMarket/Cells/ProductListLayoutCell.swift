import UIKit

private extension UIConfigurationStateCustomKey {
    static let productItemKey = UIConfigurationStateCustomKey("productItemKey")
}

private extension UIConfigurationState {
    var prevItem: ProductDetail? {
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
    private var listContentView = UIListContentView(configuration: .subtitleCell())
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
        
        let stockConstraints = [
            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor),
            stockLabel.topAnchor.constraint(equalTo: listContentView.topAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        [listContentView, stockLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        listContentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate(stockConstraints)
        
        stockLabelLayouts = stockConstraints
    }
    
    private func createPriceText(product: ProductDetail?) -> NSMutableAttributedString? {
        guard let product = product else {
            return nil
        }
        
        let spacing = " "
        
        if product.discountedPrice == 0 {
            return NSMutableAttributedString()
                .normalStyle(string: "\(product.currency) \(product.price)")
        }
        
        return NSMutableAttributedString()
            .strikeThroughStyle(string: "\(product.currency) \(product.discountedPrice)")
            .normalStyle(string: spacing)
            .normalStyle(string: "\(product.currency) \(product.price)")
    }
    
    private func createStockText(product: ProductDetail?) -> NSMutableAttributedString? {
        let soldOut = "품절"
        
        guard let product = product else {
            return nil
        }
        
        if product.stock == 0 {
            let attributedString = NSMutableAttributedString(string: soldOut)
            attributedString.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: 0, length: soldOut.count))
            
            return attributedString
        }
        
        return NSMutableAttributedString()
            .normalStyle(string: "잔여수량 : \(product.stock)")
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        var content = defaultContentConfiguration().updated(for: state)
        
//        content.image = state.prevItem?.thumbnail // imageLoader 만들어야함
        content.text = state.prevItem?.name
        content.secondaryAttributedText = createPriceText(product: state.prevItem) ?? nil
        listContentView.configuration = content
        
        stockLabel.attributedText = createPriceText(product: state.prevItem) ?? nil
    }
}

private extension NSMutableAttributedString {
    func strikeThroughStyle(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, self.length))
        attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, self.length))
        return attributedString
    }
    
    func normalStyle(string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }
}
