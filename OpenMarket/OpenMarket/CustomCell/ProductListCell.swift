import UIKit

class ProductListCell: UICollectionViewListCell {
    
    @IBOutlet var thumbnailImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var stockLabel: UILabel!
    
    static let identifier = "ListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with product: ProductDetail) {
        setupImage(with: product)
        setupNameLabel(with: product)
        setupPriceLabel(with: product)
        setupStockLabel(with: product)
    }
    
    private func setupImage(with product: ProductDetail) {
        guard let imageURL = URL(string: product.thumbnail),
            let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) else {
               print("잘못된 이미지 URL입니다.")
               return
           }
        thumbnailImage.image = image
    }
    
    private func setupNameLabel(with product: ProductDetail) {
        nameLabel.text = product.name
    }
    
    private func setupPriceLabel(with product: ProductDetail) {
        let currentPriceText = product.currency + StringSeparator.blank + String(product.price.addComma())
        if product.discountedPrice == 0 {
            priceLabel.attributedText = NSAttributedString(string: currentPriceText)
        } else {
            let previousPrice = currentPriceText.strikeThrough()
            let bargainPriceText = StringSeparator.doubleBlank + product.currency + StringSeparator.blank + String(product.bargainPrice.addComma())
            let bargainPrice = NSAttributedString(string: bargainPriceText)
            
            let priceLabelText = NSMutableAttributedString()
            priceLabelText.append(previousPrice)
            priceLabelText.append(bargainPrice)
            priceLabel.attributedText = priceLabelText
        }
    }
    
    private func setupStockLabel(with product: ProductDetail) {
        if product.stock == 0 {
            stockLabel.textColor = .systemOrange
            stockLabel.text = LabelString.outOfStock
        } else {
            stockLabel.textColor = .systemGray
            stockLabel.text = LabelString.stockTitle + String(product.stock.addComma())
        }
        
    }
    
}
