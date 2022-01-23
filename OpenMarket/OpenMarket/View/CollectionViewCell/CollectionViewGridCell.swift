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

    private let activityIndicator = UIActivityIndicatorView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockLabel = UILabel()
    private let labelStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure() {
        configureMainView()
        configureAcitivityIndicator()
        configureImageView()
        configureNameLabel()
        configurePriceLabel()
        configureStockLabel()
        configureLabelStackView()
    }
    
    private func configureMainView() {
        layer.borderColor = Attribute.borderColor
        layer.borderWidth = Attribute.borderWidth
        layer.cornerRadius = Attribute.cornerRadius
        
        addSubview(activityIndicator)
        addSubview(imageView)
        addSubview(labelStackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor, multiplier: 2.0)
        ])
    }
}

//MARK: - Open Method
extension CollectionViewGridCell {
    
    func update(from product: Product) {
        updateImageView(from: product)
        updateNameLabel(from: product)
        updatePriceLabel(from: product)
        updateStockLabel(from: product)
    }
}

//MARK: - Activity Indicator
extension CollectionViewGridCell {
    
    enum ActivityIndicatorAttribute {
        static let spacing: CGFloat = 10
        static let fractionalWidth: CGFloat = 0.7
        static let aspectRatio: CGFloat = 1
    }
    
    private func configureAcitivityIndicator() {
        activityIndicator.startAnimating()
        
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
    
    private func configureImageView() {
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
}

//MARK: - Label StackView
extension CollectionViewGridCell {
    
    enum LableStackViewAttribute {
        static let fractionalWidth: CGFloat = 0.95
    }
    
    private func configureLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        labelStackView.alignment = .center
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.addArrangedSubview(stockLabel)
        
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
    
    //MARK: - Name Label
    enum NameLabelAttribute {
        static let fontSize: CGFloat = 17
        static let fontColor: UIColor = .black
    }

    private func configureNameLabel() {
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.font = UIFont.dynamicBoldSystemFont(ofSize: NameLabelAttribute.fontSize)
    }
    
    private func updateNameLabel(from product: Product) {
        nameLabel.text = product.name
    }
    
    //MARK: - Price Label
    enum PriceLabelAttribute {
        static let textStyle: UIFont.TextStyle = .callout
        static let originalPriceFontColor: UIColor = .red
        static let bargainPriceFontColor: UIColor = .systemGray
    }
    
    private func configurePriceLabel() {
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
        
        result.adjustTextStyle(textStyle: PriceLabelAttribute.textStyle)
        priceLabel.attributedText = result
    }
    
    //MARK: - Stock Label
    enum StockLabelAttribute {
        static let spacing: CGFloat = 5
        static let textStyle: UIFont.TextStyle = .callout
        static let stockFontColor: UIColor = .systemGray
        static let soldoutFontColor: UIColor = .orange
    }
    
    private func configureStockLabel() {
        stockLabel.adjustsFontForContentSizeCategory = true
        stockLabel.font = .preferredFont(forTextStyle: StockLabelAttribute.textStyle)
    }
    
    private func updateStockLabel(from product: Product) {
        if product.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = StockLabelAttribute.soldoutFontColor
        } else {
            stockLabel.text = "잔여수량: \(product.stock)"
            stockLabel.textColor = StockLabelAttribute.stockFontColor
        }
    }
}
