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
        title: NSAttributedString,
        price: NSAttributedString,
        stock: NSAttributedString
    ) {
        self.productTitleLabel.attributedText = title
        self.productPriceLabel.attributedText = price
        self.productStockLabel.attributedText = stock
    }
    
    func setup(image: UIImage?) {
        self.productImageView.image = image
    }
}

extension ProductsCollectionViewCell {
    static let reuseIdentifier = "productCell"
}
