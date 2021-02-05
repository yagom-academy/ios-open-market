
import UIKit

class ProductGridViewCell: UICollectionViewCell {
    static let identifier: String = "ProductGridViewCell"
    let productNameLabel: UILabel = UILabel()
    let productPriceLabel: UILabel = UILabel()
    let productDiscountedPriceLabel: UILabel = UILabel()
    let productStockLabel: UILabel = UILabel()
    let productThumbnailImageView: UIImageView = UIImageView()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(productPriceLabel)
        stackView.addArrangedSubview(productDiscountedPriceLabel)
        stackView.addArrangedSubview(productStockLabel)
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.magenta.cgColor
        setUpLabel()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpLabel() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        productThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.font = .preferredFont(forTextStyle: .headline)
        productNameLabel.adjustsFontForContentSizeCategory = true
        productNameLabel.textColor = .black
        productNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        productNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        productStockLabel.translatesAutoresizingMaskIntoConstraints = false
        productStockLabel.font = .preferredFont(forTextStyle: .body)
        productStockLabel.adjustsFontSizeToFitWidth = true
        productStockLabel.adjustsFontForContentSizeCategory = true
        productStockLabel.textColor = .gray
        productStockLabel.textAlignment = .right
        productStockLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productStockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.font = .preferredFont(forTextStyle: .body)
        productPriceLabel.adjustsFontForContentSizeCategory = true
        productPriceLabel.textColor = .gray
        productPriceLabel.minimumScaleFactor = .leastNormalMagnitude
        
        productDiscountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productDiscountedPriceLabel.font = .preferredFont(forTextStyle: .body)
        productDiscountedPriceLabel.adjustsFontForContentSizeCategory = true
        productDiscountedPriceLabel.textColor = .gray
        productDiscountedPriceLabel.minimumScaleFactor = .leastNormalMagnitude
    }
    
    private func setUpConstraints() {
        contentView.addSubview(productThumbnailImageView)
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            productThumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productThumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productThumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            productThumbnailImageView.heightAnchor.constraint(equalTo: productThumbnailImageView.widthAnchor, multiplier: 1),

            stackView.topAnchor.constraint(equalTo: productThumbnailImageView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: productThumbnailImageView.centerXAnchor)

        ])
    }
    
    override func prepareForReuse() {
        productThumbnailImageView.image = nil
        productStockLabel.textColor = .gray
    }
}

