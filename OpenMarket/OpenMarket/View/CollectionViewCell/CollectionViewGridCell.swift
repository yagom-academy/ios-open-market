import UIKit
import JNomaKit

class CollectionViewGridCell: UICollectionViewCell {

    typealias Product = NetworkingAPI.ProductListQuery.Response.Page
    
    enum LayoutAttribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
        static let borderColor: CGColor = UIColor.systemGray.cgColor
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 15
        
        enum ImageView {
            static let fractionalWidth: CGFloat = 0.7
            static let aspectRatio: CGFloat = 1
        }
        
        enum LableStackView {
            static let fractionalWidth: CGFloat = 0.95
        }
        
        enum NameLabel {
            static let fontSize: CGFloat = 17
        }
        
        enum PriceLabel {
            static let textStyle: UIFont.TextStyle = .callout
            static let originalPriceFontColor: UIColor = .red
            static let bargainPriceFontColor: UIColor = .systemGray
        }
        
        enum StockLabel {
            static let textStyle: UIFont.TextStyle = .callout
            static let stockFontColor: UIColor = .systemGray
            static let soldoutFontColor: UIColor = .orange
        }
    }

    private let activityIndicator = UIActivityIndicatorView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockLabel = UILabel()
    private let labelStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        organizeViewHierarchy()
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(from product: Product) {
        updateImageView(from: product)
        updateNameLabel(from: product)
        updatePriceLabel(from: product)
        updateStockLabel(from: product)
    }
    
    private func organizeViewHierarchy() {
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
        
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.addArrangedSubview(stockLabel)
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
    
    //MARK: - MainView
    private func configureMainView() {
        layer.borderColor = LayoutAttribute.borderColor
        layer.borderWidth = LayoutAttribute.borderWidth
        layer.cornerRadius = LayoutAttribute.cornerRadius

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 1.5)
        ])
    }
}

//MARK: - Activity Indicator
extension CollectionViewGridCell {
    
    private func configureAcitivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.setContentHuggingPriority(.defaultLow, for: .vertical)
        activityIndicator.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}

//MARK: - ImageView
extension CollectionViewGridCell {

    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: LayoutAttribute.largeSpacing),
            imageView.widthAnchor.constraint(equalTo: widthAnchor,
                                             multiplier: LayoutAttribute.ImageView.fractionalWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                              multiplier: LayoutAttribute.ImageView.aspectRatio),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func updateImageView(from product: Product) {
        ImageLoader.load(from: product.thumbnail) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.sync {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Label StackView
extension CollectionViewGridCell {
    
    private func configureLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        labelStackView.alignment = .center

        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor,
                                                constant: LayoutAttribute.largeSpacing),
            labelStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                constant: LayoutAttribute.largeSpacing),
            labelStackView.widthAnchor.constraint(equalTo: widthAnchor,
                                                  multiplier: LayoutAttribute.LableStackView.fractionalWidth),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -1 * LayoutAttribute.largeSpacing)
        ])
    }
}

//MARK: - Name Label
extension CollectionViewGridCell {

    private func configureNameLabel() {
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func updateNameLabel(from product: Product) {
        nameLabel.attributedText = JNAttributedStringMaker.attributedString(
            text: product.name,
            textStyle: .body,
            fontColor: .black,
            attributes: [.bold]
        )
    }
}

//MARK: - Price Label
extension CollectionViewGridCell {
    
    private func configurePriceLabel() {
        priceLabel.numberOfLines = 0
        priceLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func updatePriceLabel(from product: Product) {
        let lineBreak = NSMutableAttributedString(string: "\n")
        let result = NSMutableAttributedString(string: "")
        if product.price != product.bargainPrice {
            let originalCurrency = JNAttributedStringMaker.attributedString(
                text: "\(product.currency.rawValue) ",
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.originalPriceFontColor,
                attributes: [.strikeThrough]
            )
            let originalPrice = JNAttributedStringMaker.attributedString(
                text: product.price.description,
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.originalPriceFontColor,
                attributes: [.decimal, .strikeThrough]
            )
            let bargainCurrency = JNAttributedStringMaker.attributedString(
                text: "\(product.currency.rawValue) ",
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor
            )
            let bargainPrice = JNAttributedStringMaker.attributedString(
                text: product.bargainPrice.description,
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor,
                attributes: [.decimal]
            )
            result.append(originalCurrency)
            result.append(originalPrice)
            result.append(lineBreak)
            result.append(bargainCurrency)
            result.append(bargainPrice)
        } else {
            let bargainCurrency = JNAttributedStringMaker.attributedString(
                text: "\(product.currency.rawValue) ",
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor
            )
            let bargainPrice = JNAttributedStringMaker.attributedString(
                text: product.bargainPrice.description,
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor,
                attributes: [.decimal]
            )
            
            result.append(bargainCurrency)
            result.append(bargainPrice)
        }

        priceLabel.attributedText = result
    }
}

//MARK: - Stock Label
extension CollectionViewGridCell {
    
    private func configureStockLabel() {
        stockLabel.adjustsFontForContentSizeCategory = true
        stockLabel.font = .preferredFont(forTextStyle: LayoutAttribute.StockLabel.textStyle)
    }
    
    private func updateStockLabel(from product: Product) {
        if product.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = LayoutAttribute.StockLabel.soldoutFontColor
        } else {
            stockLabel.text = "잔여수량: \(product.stock)"
            stockLabel.textColor = LayoutAttribute.StockLabel.stockFontColor
        }
    }
}
