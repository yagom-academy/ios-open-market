import UIKit

class ProductDetailViewController: UIViewController {
    // MARK: - Property
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var totalPageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var previousPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    let apiManager = APIManager.shared
    private var imageDataSource: UICollectionViewDiffableDataSource<Section, Image>?
    var productID: Int?

    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageCollectionView()
        getProductDetail()
    }
    
    // MARK: - Setup CollectionView Method
    func setupImageCollectionView() {
        imageCollectionView.collectionViewLayout = OpenMarketViewLayout.productImages
        imageCollectionView.delegate = self
        imageCollectionView.decelerationRate = .fast
        imageCollectionView.isPagingEnabled = true
        setupImageCollectionViewDataSource()
    }
    
    func setupImageCollectionViewDataSource() {
        imageDataSource = UICollectionViewDiffableDataSource<Section, Image>(collectionView: imageCollectionView) { collectionView, indexPath, product in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.identifier, for: indexPath) as? ProductImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setupImage(with: product)
            return cell
        }
    }
    
    private func populate(with products: [Image]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        imageDataSource?.apply(snapshot)
    }
    
    // MARK: - Setup ProductDetailView Method
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
        let productImages = product.images ?? []
        setupTotalPageLabel(with: productImages)
        setupNameLabel(with: product)
        setupStockLabel(with: product)
        setupPriceLabel(with: product)
        setupDescriptionTextView(with: product)
        populate(with: productImages)
    
    }
    
    private func setupTotalPageLabel(with productImages: [Image]) {
        totalPageLabel.text = String(productImages.count)
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

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Setup CollectionViewFlowLayout Method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    // MARK: - Calculate Page Method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
        currentPageLabel.text = String(currentPage)
    }
}
