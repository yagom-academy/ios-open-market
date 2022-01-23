import UIKit

class CollectionViewListCell: UICollectionViewListCell {
    
    enum Attribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
    }
    
    typealias Product = NetworkingAPI.ProductListQuery.Response.Page
    
    private let activityIndicator = UIActivityIndicatorView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let labelStackView = UIStackView()
    private let stockLabel = UILabel()
    private let chevronButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    private func configure() {
        configureMainView()
        configureActivityIndicator()
        configureImageView()
        configureNameLabel()
        configurePriceLabel()
        configureLabelStackView()
        configureStockLabel()
        configureChevronButton()
    }

    private func configureMainView() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(imageView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(stockLabel)
        contentView.addSubview(chevronButton)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: activityIndicator.heightAnchor,
                                                constant: Attribute.largeSpacing * 2),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor,
                                                constant: Attribute.largeSpacing * 2)
        ])
    }
}

//MARK: - Open Method
extension CollectionViewListCell {
    
    func update(from product: Product) {
        updateImageView(from: product)
        updateNameLabel(from: product)
        updatePriceLabel(from: product)
        updateStockLabel(from: product)
    }
}

//MARK: - ActivityIndicator
extension CollectionViewListCell {
    
    enum AcitivityIndicatorAttribute {
        static let spacing: CGFloat = 5
        static let fractionalWidth: CGFloat = 0.2
        static let aspectRatio: CGFloat = 1.0
    }
    
    private func configureActivityIndicator() {
        activityIndicator.startAnimating()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: Attribute.largeSpacing),
            activityIndicator.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                     multiplier: AcitivityIndicatorAttribute.fractionalWidth),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor,
                                                      multiplier: AcitivityIndicatorAttribute.aspectRatio),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

//MARK: - ImageView
extension CollectionViewListCell {
    
    enum ImageViewAttribute {
        static let fractionalWidth: CGFloat = 0.2
        static let aspectRatio: CGFloat = 1.0
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: Attribute.largeSpacing),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                             multiplier: ImageViewAttribute.fractionalWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                              multiplier: ImageViewAttribute.aspectRatio),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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

//MARK: - LabelStackView
extension CollectionViewListCell {

    private func configureLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: activityIndicator.trailingAnchor,
                                                    constant: Attribute.smallSpacing),
            labelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                                    constant: Attribute.smallSpacing),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: Attribute.largeSpacing),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -1 * Attribute.largeSpacing)
        ])
    }
    
    //MARK: - NameLabel
    enum NameLabelAttribute {
        static let fontSize: CGFloat = 17
        static let fontColor: UIColor = .black
    }
    
    private func configureNameLabel() {
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.font = UIFont.dynamicBoldSystemFont(ofSize: NameLabelAttribute.fontSize)
    }
    
    private func updateNameLabel(from product: Product) {
        nameLabel.text = product.name
    }
    
    //MARK: - PriceLabel
    enum PriceLabelAttribute {
        static let textStyle: UIFont.TextStyle = .callout
        static let originalPriceFontColor: UIColor = .red
        static let bargainPriceFontColor: UIColor = .systemGray
    }
    
    private func configurePriceLabel() {
        priceLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func updatePriceLabel(from product: Product) {
        let blank = NSMutableAttributedString(string: " ")
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
            result.append(blank)
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
}

//MARK: - StockLabel
extension CollectionViewListCell {
    
    enum StockLabelAttribute {
        static let textStyle: UIFont.TextStyle = .callout
        static let stockFontColor: UIColor = .systemGray
        static let soldoutFontColor: UIColor = .orange
    }
    
    private func configureStockLabel() {
        stockLabel.adjustsFontForContentSizeCategory = true
        stockLabel.font = .preferredFont(forTextStyle: StockLabelAttribute.textStyle)
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: Attribute.largeSpacing),
            stockLabel.trailingAnchor.constraint(equalTo: chevronButton.leadingAnchor,
                                                constant: -1 * Attribute.largeSpacing),
        ])
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

//MARK: - ChevronButton
extension CollectionViewListCell {
    
    private func configureChevronButton() {
        chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronButton.tintColor = .systemGray
        
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chevronButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -1 * Attribute.largeSpacing),
            chevronButton.centerYAnchor.constraint(equalTo: stockLabel.centerYAnchor)
        ])
    }
}
