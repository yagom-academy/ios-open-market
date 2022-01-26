import UIKit

class ProductDetailViewController: UIViewController {

    let apiManager = APIManager.shared
    var productID: Int?
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var totalPageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var previousPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
    }
    
    private func getProductDetail() {
        guard let productID = productID else { return }
        apiManager.checkProductDetail(id: productID) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.setup(with: product)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setup(with product: ProductDetail) {
        setupNameLabel(with: product)
        setupStockLabel(with: product)
        setupPriceLabel(with: product)
        setupDescriptionTextView(with: product)
    }
    
    private func setupNameLabel(with product: ProductDetail) {
        nameLabel.text = product.name
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
    
    private func setupPriceLabel(with product: ProductDetail) {
        let currentPriceText = product.currency.unit + StringSeparator.blank + String(product.price.addComma())
        if product.discountedPrice == 0 {
            previousPriceLabel.isHidden = true
            priceLabel.text = currentPriceText
        } else {
            let previousPrice = currentPriceText.strikeThrough()
            let bargainPriceText = StringSeparator.doubleBlank + product.currency.unit + StringSeparator.blank + String(product.bargainPrice.addComma())
            previousPriceLabel.attributedText = previousPrice
            priceLabel.text = bargainPriceText
        }
    }
    
    private func setupDescriptionTextView(with product: ProductDetail) {
        descriptionTextView.text = product.description ?? ""
    }
    
}
