import UIKit

private enum Design {
    static let maximumImageWidth: CGFloat = 50
    static let maximumImageHeight: CGFloat = 50
    static let padding: CGFloat = 10
    static let stockTrailingMargin: CGFloat = -8
    static let listContentViewTopMargin: CGFloat = 5
    static let listContentViewBottomMargin: CGFloat = -5
}

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
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
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
        
        [listContentView, stockLabel, seperatorView].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let stockConstraints = [
            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: listContentView.centerYAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Design.stockTrailingMargin),
            stockLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width / 4)
        ]
        
        NSLayoutConstraint.activate([
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.listContentViewTopMargin),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Design.listContentViewBottomMargin),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate(stockConstraints)
        
        stockLabelLayouts = stockConstraints
    }
    
    override func prepareForReuse() {
        listContentView.configuration = defaultContentConfiguration()
        stockLabel.text = nil
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        ImageLoader.loadImage(from: state.product?.thumbnail) { image in
            var content = self.defaultConfiguration().updated(for: state)
                
            content.textToSecondaryTextVerticalPadding = Design.padding
            content.imageToTextPadding = Design.padding
            content.image = image
            content.imageProperties.maximumSize = CGSize(width: Design.maximumImageWidth, height: Design.maximumImageHeight)
            
            content.text = state.product?.name
            content.textProperties.numberOfLines = 2
            content.textProperties.font = .preferredFont(forTextStyle: .headline)
            
            content.secondaryAttributedText = AttributedTextCreator.createPriceText(product: state.product) ?? nil
            content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
            content.textProperties.numberOfLines = 1
            self.listContentView.configuration = content
            
            self.stockLabel.attributedText = AttributedTextCreator.createStockText(product: state.product) ?? nil
        }
    }
}
