import UIKit

private enum Design {
    static let productStackViewSpacing: CGFloat = 5
    static let productStackViewTopMargin: CGFloat = 8
    static let productStackViewLeadingMargin: CGFloat = 8
    static let productStackViewBottomMargin: CGFloat = -8
    static let productStackViewTrailingMargin: CGFloat = -8
    static let productImageViewLeadingMargin: CGFloat = 5
    static let productImageViewTrailingMargin: CGFloat = -5
}

class ProductGridLayoutCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUILayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = Design.productStackViewSpacing
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let productPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    func configUI(with product: ProductDetail) {
        guard let price = product.price.formattedToDecimal,
              let bargainPrice = product.bargainPrice.formattedToDecimal else {
            return
        }
        
        if product.discountedPrice == 0 {
            priceLabel.isHidden = true
        } else {
            priceLabel.isHidden = false
            priceLabel.attributedText = NSMutableAttributedString.strikeThroughStyle(string: "\(product.currency.unit) \(price)")
        }
        
        productNameLabel.text = product.name
        productImageView.image = ImageLoader.loadImage(from: product.thumbnail)
        bargainPriceLabel.attributedText = NSMutableAttributedString.normalStyle(string: "\(product.currency.unit) \(bargainPrice)")
        productStockLabel.attributedText = AttributedTextCreator.createStockText(product: product)
    }
    
    private func configUILayout() {
        [priceLabel, bargainPriceLabel].forEach { label in
            productPriceStackView.addArrangedSubview(label)
        }
        
        [productImageView, productNameLabel, productPriceStackView, productStockLabel].forEach { view in
            productStackView.addArrangedSubview(view)
        }
        
        self.contentView.addSubview(productStackView)
        productStackView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Design.productStackViewTopMargin),
            productStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Design.productStackViewLeadingMargin),
            productStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: Design.productStackViewBottomMargin),
            productStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: Design.productStackViewTrailingMargin),
            
            productImageView.leadingAnchor.constraint(equalTo: productStackView.leadingAnchor, constant: Design.productImageViewLeadingMargin),
            productImageView.trailingAnchor.constraint(equalTo: productStackView.trailingAnchor, constant: Design.productImageViewTrailingMargin),
            productImageView.heightAnchor.constraint(lessThanOrEqualToConstant: self.contentView.frame.height / 2)
        ])
    }
}
