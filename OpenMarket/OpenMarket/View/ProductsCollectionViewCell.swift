import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productStockLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.cornerRadius = 10
    }
    
    func setup(
        titleLabel: NSAttributedString,
        priceLabel: NSAttributedString,
        stockLabel: NSAttributedString
    ) {
        self.productTitleLabel.attributedText = title
        self.productPriceLabel.attributedText = price
        self.productStockLabel.attributedText = stockLabl
    }
    
    func setup(imageView: UIImage?) {
        self.productImageView.image = imageView
    }
}

extension ProductsCollectionViewCell {
    static let reuseIdentifier = "productCell"
}
