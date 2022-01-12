import UIKit

class ProductListCell: UICollectionViewListCell {
    
    struct StringSeparator {
        static let blank = " "
        static let doubleBlank = "  "
    }
    
    struct LabelString {
        static let outOfStock = "품절"
        static let stockTitle = "잔여수량 : "
    }
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var stockLabel: UILabel!
    
    static let identifier = "ListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with product: ProductDetail) {
        setupCellAccessory()
        setupImage(with: product)
        setupPriceLabel(with: product)
        setupStockLabel(with: product)
    }
    
    func setupCellAccessory() {
        self.accessories = [.disclosureIndicator()]
    }
    
    func setupImage(with product: ProductDetail) {
        guard let imageURL = URL(string: product.thumbnail),
            let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) else {
               print("잘못된 이미지 URL입니다.")
               return
           }
        thumbnailImage.image = image
    }
    
    func setupPriceLabel(with product: ProductDetail) {
        let currentPriceText = product.currency + StringSeparator.blank + String(product.price)
        if product.discountedPrice == 0 {
            priceLabel.attributedText = NSAttributedString(string: currentPriceText)
        } else {
            let previousPrice = currentPriceText.strikeThrough()
            let bargainPriceText = StringSeparator.doubleBlank + product.currency + StringSeparator.blank + String(product.bargainPrice)
            let bargainPrice = NSAttributedString(string: bargainPriceText)
            
            let priceLabelText = NSMutableAttributedString()
            priceLabelText.append(previousPrice)
            priceLabelText.append(bargainPrice)
            priceLabel.attributedText = priceLabelText
        }
    }
    
    func setupStockLabel(with product: ProductDetail) {
        if product.stock == 0 {
            stockLabel.text = LabelString.outOfStock
            stockLabel.textColor = .systemOrange
        } else {
            stockLabel.text = LabelString.stockTitle + String(product.stock)
        }
    }
    
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        let totalRange = NSRange(location: 0, length: attributeString.length)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: totalRange)
        attributeString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: totalRange)
        return attributeString
    }
}
