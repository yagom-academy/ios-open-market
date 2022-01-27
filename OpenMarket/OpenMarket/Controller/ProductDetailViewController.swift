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
    private var imageDataSource: UICollectionViewDiffableDataSource<Section, Image>?

    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
        setupImageCollectionViewLayout()
        setupImageCollectionView()
        imageCollectionView.delegate = self
        imageCollectionView.decelerationRate = .fast
        imageCollectionView.isPagingEnabled = true
    }
    
    func setupImageCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        imageCollectionView.collectionViewLayout = layout
    }
    
    func setupImageCollectionView() {
        imageDataSource = UICollectionViewDiffableDataSource<Section, Image>(collectionView: imageCollectionView) { collectionView, indexPath, product in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setupImage(with: product)
            return cell
        }
    }
    
    private func getProductDetail() {
        guard let productID = productID else { return }
        apiManager.checkProductDetail(id: productID) { result in
            switch result {
            case .success(let product):
                let productImages = product.images ?? []
                DispatchQueue.main.async {
                    self.setup(with: product)
                    self.populate(with: productImages)
                    self.totalPageLabel.text = String(productImages.count)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func populate(with products: [Image]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        imageDataSource?.apply(snapshot)
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

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
        currentPageLabel.text = String(nowPage)
        print(scrollView.contentOffset)
        print(scrollView.frame.width)
    }
}
