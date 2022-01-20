import UIKit

class CollectionViewGridCell: UICollectionViewCell {

    typealias Product = NetworkingAPI.ProductListQuery.Response.Page
    
    enum Attribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
        static let borderColor: CGColor = UIColor.systemGray.cgColor
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 15
    }

    private var activityIndicator: UIActivityIndicatorView!
    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var priceLabel: UILabel!
    private var stockLabel: UILabel!
    private var labelStackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        createAllComponents()
        configureCellAttribute()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Opened Method
    func updateAllComponents(from product: Product) {
        updateImageView(from: product)
        updateNameLabel(from: product)
        updatePriceLabel(from: product)
        updateStockLabel(from: product)
    }
    
    private func createAllComponents() {
        createAcitivityIndicator()
        createImageView()
        createNameLabel()
        createPriceLabel()
        createStockLabel()
        createLabelStackView()
    }
    
    private func configureCellAttribute() {
        layer.borderColor = Attribute.borderColor
        layer.borderWidth = Attribute.borderWidth
        layer.cornerRadius = Attribute.cornerRadius
    }
    
    private func configureLayout() {
        configureMainViewLayout()
        configureActivityIndicatorLayout()
        configureImageViewLayout()
        configureLabelStackViewLayout()
    }
    
    private func configureMainViewLayout() {
        addSubview(activityIndicator)
        addSubview(imageView)
        addSubview(labelStackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor, multiplier: 2.0)
        ])
    }
}

//MARK: - Activity Indicator
extension CollectionViewGridCell {
    
    enum ActivityIndicatorAttribute {
        static let spacing: CGFloat = 10
        static let fractionalWidth: CGFloat = 0.7
        static let aspectRatio: CGFloat = 1
    }
    
    private func createAcitivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
    }
    
    private func configureActivityIndicatorLayout() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor,
                                           constant: ActivityIndicatorAttribute.spacing),
            activityIndicator.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: ActivityIndicatorAttribute.fractionalWidth),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor,
                                              multiplier: ActivityIndicatorAttribute.aspectRatio),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

//MARK: - ImageView
extension CollectionViewGridCell {

    enum ImageViewAttribute {
        static let spacing: CGFloat = 10
        static let fractionalWidth: CGFloat = 0.7
        static let aspectRatio: CGFloat = 1
    }
    
    private func createImageView() {
        imageView = UIImageView()
    }
    
    private func updateImageView(from product: Product) {
        ImageLoader.load(from: product.thumbnail) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.sync {
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: ActivityIndicatorAttribute.spacing),
            imageView.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: ActivityIndicatorAttribute.fractionalWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                              multiplier: ActivityIndicatorAttribute.aspectRatio),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

//MARK: - Name Label
extension CollectionViewGridCell {
    
    enum NameLabelAttribute {
        static let textStyle: UIFont.TextStyle = .title3
        static let fontColor: UIColor = .black
    }

    private func createNameLabel() {
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func updateNameLabel(from product: Product) {
        let result = NSMutableAttributedString(string: product.name)
        result.adjustBold()
        result.changeColor(to: NameLabelAttribute.fontColor)
        result.adjustDynamicType(textStyle: NameLabelAttribute.textStyle)
        
        nameLabel.attributedText = result
    }
}

//MARK: - Price Label
extension CollectionViewGridCell {

    enum PriceLabelAttribute {
        static let textStyle: UIFont.TextStyle = .callout
        static let originalPriceFontColor: UIColor = .red
        static let bargainPriceFontColor: UIColor = .systemGray
    }
    
    private func createPriceLabel() {
        priceLabel = UILabel()
        priceLabel.numberOfLines = 0
        priceLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func updatePriceLabel(from product: Product) {
        let blank = NSMutableAttributedString(string: " ")
        let lineBreak = NSMutableAttributedString(string: "\n")
        let currency = NSMutableAttributedString(string: product.currency.rawValue)
        let originalPrice = NSMutableAttributedString(string: product.price.description)
        originalPrice.adjustDecimal()
        let bargainPrice = NSMutableAttributedString(string: product.bargainPrice.description)
        bargainPrice.adjustDecimal()
        
        let result = NSMutableAttributedString(string: "")
        if product.price != product.bargainPrice {
            let originalPriceDescription = NSMutableAttributedString()
            originalPriceDescription.append(currency)
            originalPriceDescription.append(blank)
            originalPriceDescription.append(originalPrice)
            originalPriceDescription.adjustStrikeThrough()
            originalPriceDescription.changeColor(to: PriceLabelAttribute.originalPriceFontColor)
            
            let bargainPriceDescription = NSMutableAttributedString()
            bargainPriceDescription.append(currency)
            bargainPriceDescription.append(blank)
            bargainPriceDescription.append(bargainPrice)
            bargainPriceDescription.changeColor(to: PriceLabelAttribute.bargainPriceFontColor)
            
            result.append(originalPriceDescription)
            result.append(lineBreak)
            result.append(bargainPriceDescription)
        } else {
            let bargainPriceDescription = NSMutableAttributedString()
            bargainPriceDescription.append(currency)
            bargainPriceDescription.append(blank)
            bargainPriceDescription.append(bargainPrice)
            bargainPriceDescription.changeColor(to: PriceLabelAttribute.bargainPriceFontColor)

            result.append(bargainPriceDescription)
        }
        
        result.adjustDynamicType(textStyle: PriceLabelAttribute.textStyle)
        priceLabel.attributedText = result
    }
}

//MARK: - Stock Label
extension CollectionViewGridCell {
    enum StockLabelAttribute {
        static let spacing: CGFloat = 5
        static let textStyle: UIFont.TextStyle = .callout
        static let stockFontColor: UIColor = .systemGray
        static let soldoutFontColor: UIColor = .orange
    }
    
    private func createStockLabel() {
        stockLabel = UILabel()
        stockLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func updateStockLabel(from product: Product) {
        let result = NSMutableAttributedString()
        if product.stock == 0 {
            result.append(NSAttributedString(string: "품절"))
            result.changeColor(to: StockLabelAttribute.soldoutFontColor)
        } else {
            result.append(NSAttributedString(string: "잔여수량: \(product.stock)"))
            result.changeColor(to: StockLabelAttribute.stockFontColor)
        }
        
        result.adjustDynamicType(textStyle: StockLabelAttribute.textStyle)
        stockLabel.attributedText = result
    }
}

//MARK: - Label StackView
extension CollectionViewGridCell {
    
    enum LableStackViewAttribute {
        static let fractionalWidth: CGFloat = 0.95
    }
    
    private func createLabelStackView() {
        labelStackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                priceLabel,
                stockLabel
            ]
        )
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        labelStackView.alignment = .center
    }
    
    private func configureLabelStackViewLayout() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor,
                                                constant: Attribute.largeSpacing),
            labelStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                constant: Attribute.largeSpacing),
            labelStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                  multiplier: LableStackViewAttribute.fractionalWidth),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -1 * Attribute.largeSpacing)
        ])
    }
}
