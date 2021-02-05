
import UIKit

class ProductListTableViewCell: UITableViewCell {
    static let identifier: String = "ProductListTableViewCell"
    let productNameLabel: UILabel = UILabel()
    let productPriceLabel: UILabel = UILabel()
    let productDiscountedPriceLabel: UILabel = UILabel()
    let productStockLabel: UILabel = UILabel()
    let productThumbnailImageView: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpImageView()
        setUpLabel()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImageView() {
        productThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpLabel() {
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
        
        productDiscountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productDiscountedPriceLabel.font = .preferredFont(forTextStyle: .body)
        productDiscountedPriceLabel.adjustsFontForContentSizeCategory = true
        productDiscountedPriceLabel.textColor = .gray
        
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.font = .preferredFont(forTextStyle: .body)
        productPriceLabel.adjustsFontForContentSizeCategory = true
        productPriceLabel.textColor = .red
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(productNameLabel)
        self.contentView.addSubview(productPriceLabel)
        self.contentView.addSubview(productDiscountedPriceLabel)
        self.contentView.addSubview(productThumbnailImageView)
        self.contentView.addSubview(productStockLabel)
        
        NSLayoutConstraint.activate([
            productThumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productThumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productThumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            productThumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productNameLabel.leadingAnchor.constraint(equalTo: productThumbnailImageView.trailingAnchor, constant: 10),
            
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            productPriceLabel.leadingAnchor.constraint(equalTo: productThumbnailImageView.trailingAnchor, constant: 5),
            productPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        
            productDiscountedPriceLabel.topAnchor.constraint(equalTo: productPriceLabel.topAnchor),
            productDiscountedPriceLabel.leadingAnchor.constraint(equalTo: productPriceLabel.trailingAnchor, constant: 5),
            productDiscountedPriceLabel.bottomAnchor.constraint(equalTo: productPriceLabel.bottomAnchor),
            
            productStockLabel.topAnchor.constraint(equalTo: productNameLabel.topAnchor),
            productStockLabel.leadingAnchor.constraint(equalTo: productNameLabel.trailingAnchor, constant: 5),
            productStockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
        ])
    }
    override func prepareForReuse() {
        productThumbnailImageView.image = nil
        productStockLabel.textColor = .gray
    }
}
