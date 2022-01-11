import UIKit

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
        stackView.spacing = 5
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
        stackView.distribution = .fillEqually
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
        if product.discountedPrice == 0 {
            priceLabel.isHidden = true
        } else {
            priceLabel.isHidden = false
            priceLabel.attributedText = NSMutableAttributedString.strikeThroughStyle(string: "\(product.currency) \(product.price)")
        }
        
        productNameLabel.text = product.name
        productImageView.image = ImageLoader.loadImage(from: product.thumbnail)
        
        bargainPriceLabel.attributedText = NSMutableAttributedString.normalStyle(string: "\(product.currency) \(product.bargainPrice)")

        productStockLabel.attributedText = AttributedTextCreator.createStockText(product: product)
    }
    
    private func configUILayout() {
        [priceLabel, bargainPriceLabel].forEach {
            productPriceStackView.addArrangedSubview($0)
        }
        
        [productImageView, productNameLabel, productPriceStackView, productStockLabel].forEach {
            productStackView.addArrangedSubview($0)
        }
        
        productPriceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        self.contentView.addSubview(productStackView)
        
        productStackView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            productStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            productStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            productStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            
            productImageView.topAnchor.constraint(equalTo: productStackView.topAnchor, constant: 5),
            productImageView.leadingAnchor.constraint(equalTo: productStackView.leadingAnchor, constant: 5),
            productImageView.trailingAnchor.constraint(equalTo: productStackView.trailingAnchor, constant: -5),
            productImageView.heightAnchor.constraint(equalToConstant: self.contentView.frame.height / 1.7)
        ])
    }
}
