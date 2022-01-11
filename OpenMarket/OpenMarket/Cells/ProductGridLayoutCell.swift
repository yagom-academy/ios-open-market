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
        [priceLabel, bargainPriceLabel].forEach {
            productPriceStackView.addArrangedSubview($0)
        }
        
        [productImageView, productNameLabel, productPriceStackView, productStockLabel].forEach {
            productStackView.addArrangedSubview($0)
        }
        
        if product.discountedPrice == 0 {
            priceLabel.isHidden = true
        } else {
            priceLabel.isHidden = false
            priceLabel.attributedText = NSMutableAttributedString.strikeThroughStyle(string: "\(product.price)")
        }
        
        bargainPriceLabel.attributedText = NSMutableAttributedString.normalStyle(string: "\(product.bargainPrice)")

        productStockLabel.attributedText = AttributedTextCreator.createStockText(product: product)
    }
    
    private func configUILayout() {
        self.contentView.addSubview(productStackView)
        
        productStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            productStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            productStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            productStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
        ])
    }
}
