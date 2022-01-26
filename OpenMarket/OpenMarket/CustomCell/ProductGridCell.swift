import UIKit

class ProductGridCell: UICollectionViewCell {

    @IBOutlet weak var gridThumbnailImage: UIImageView!
    @IBOutlet weak var gridNameLabel: UILabel!
    @IBOutlet weak var gridPriceLabel: UILabel!
    @IBOutlet weak var gridStockLabel: UILabel!
    
    static let identifier = "GridCell"
    var productID: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func setup(with product: ProductDetail) {
        productID = product.id
        setupImage(with: product)
        setupNameLabel(with: product)
        setupPriceLabel(with: product)
        setupStockLabel(with: product)
    }
    
    func setupImage(with product: ProductDetail) {
        gridThumbnailImage.image = UIImage(data: product.thumbnail)
    }
    
    private func setupNameLabel(with product: ProductDetail) {
        gridNameLabel.text = product.name
    }
    
    private func setupPriceLabel(with product: ProductDetail) {
        let currentPriceText = product.currency.unit + StringSeparator.blank + String(product.price.addComma())
        if product.discountedPrice == 0 {
            gridPriceLabel.attributedText = NSAttributedString(string: currentPriceText)
        } else {
            let previousPrice = currentPriceText.strikeThrough()
            let bargainPriceText = StringSeparator.newLine + product.currency.unit + StringSeparator.blank + String(product.bargainPrice.addComma())
            let bargainPrice = NSAttributedString(string: bargainPriceText)
            
            let priceLabelText = NSMutableAttributedString()
            priceLabelText.append(previousPrice)
            priceLabelText.append(bargainPrice)
            gridPriceLabel.attributedText = priceLabelText
        }
    }
    
    private func setupStockLabel(with product: ProductDetail) {
        if product.stock == 0 {
            gridStockLabel.textColor = .systemOrange
            gridStockLabel.text = LabelString.outOfStock
            
        } else {
            gridStockLabel.textColor = .systemGray
            gridStockLabel.text = LabelString.stockTitle + String(product.stock.addComma())
        }
    }

}
