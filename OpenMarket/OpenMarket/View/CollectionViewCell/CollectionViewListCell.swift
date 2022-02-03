import UIKit
import JNomaKit

class CollectionViewListCell: UICollectionViewListCell {
    
    enum LayoutAttribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
        
        enum AcitivityIndicator {
            static let fractionalWidth: CGFloat = 0.2
            static let aspectRatio: CGFloat = 1.0
        }
        
        enum ImageView {
            static let fractionalWidth: CGFloat = 0.2
            static let aspectRatio: CGFloat = 1.0
        }
        
        enum NameLabel {
            static let fontSize: CGFloat = 17
            static let fontColor: UIColor = .black
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
        
        enum ChevronButton {
            static let fontColor: UIColor = .systemGray
        }
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
        contentView.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(priceLabel)
        
        contentView.addSubview(stockLabel)
        contentView.addSubview(chevronButton)
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

    //MARK: - MAinView
    private func configureMainView() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: activityIndicator.heightAnchor,
                                                constant: LayoutAttribute.largeSpacing * 2),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor,
                                                constant: LayoutAttribute.largeSpacing * 2)
        ])
    }
}

//MARK: - ActivityIndicator
extension CollectionViewListCell {
    
    private func configureActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: imageView.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
}

//MARK: - ImageView
extension CollectionViewListCell {
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: LayoutAttribute.largeSpacing),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                             multiplier: LayoutAttribute.ImageView.fractionalWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                              multiplier: LayoutAttribute.ImageView.aspectRatio),
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

        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: activityIndicator.trailingAnchor,
                                                    constant: LayoutAttribute.smallSpacing),
            labelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                                    constant: LayoutAttribute.smallSpacing),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: LayoutAttribute.largeSpacing),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -1 * LayoutAttribute.largeSpacing)
        ])
    }
}

//MARK: - NameLabel
extension CollectionViewListCell {
    private func configureNameLabel() {
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

//MARK: - PriceLabel
extension CollectionViewListCell {
    
    private func configurePriceLabel() {
        priceLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func updatePriceLabel(from product: Product) {
        let blank = NSMutableAttributedString(string: " ")
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
            result.append(blank)
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

//MARK: - StockLabel
extension CollectionViewListCell {
    
    private func configureStockLabel() {
        stockLabel.adjustsFontForContentSizeCategory = true
        stockLabel.font = .preferredFont(forTextStyle: LayoutAttribute.StockLabel.textStyle)
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: LayoutAttribute.largeSpacing),
            stockLabel.trailingAnchor.constraint(equalTo: chevronButton.leadingAnchor,
                                                constant: -1 * LayoutAttribute.largeSpacing),
        ])
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

//MARK: - ChevronButton
extension CollectionViewListCell {
    
    private func configureChevronButton() {
        chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronButton.tintColor = LayoutAttribute.ChevronButton.fontColor
        
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chevronButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -1 * LayoutAttribute.largeSpacing),
            chevronButton.centerYAnchor.constraint(equalTo: stockLabel.centerYAnchor)
        ])
    }
}
