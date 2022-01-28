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
    
    private let apiManager = APIManager.shared
    private var imageDataSource: UICollectionViewDiffableDataSource<Section, Image>?
    var productImages = [UIImage]()
    var productDetail: ProductDetail?
    var productID: Int?
    var secret: String?
    
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductSecret()
        getProductDetail()
        setupImageCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDetailView), name: NSNotification.Name("UpdateView"), object: nil)
    }
    
    @objc func updateDetailView() {
        getProductDetail()
    }
    
    @IBAction func tapEditDeleteButton(_ sender: Any) {
        let alert = createAlert()
        present(alert, animated: true, completion: nil)
    }
    
    func getProductSecret() {
        guard let productID = productID else { return }
        apiManager.checkProductSecret(id: productID) { result in
            switch result {
            case .success(let data):
                self.secret = String(decoding: data, as: UTF8.self)
            case .failure(_):
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem = nil
                }
            }
        }
    }
    // MARK: - Setup ProductDetailView Method
    private func getProductDetail() {
        guard let productID = productID else { return }
        apiManager.checkProductDetail(id: productID) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.productDetail = product
                    self.appendProductImages(with: product.images)
                    self.setup(with: product)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func appendProductImages(with images: [Image]?) {
        guard let images = images else { return }
        images.forEach { image in
            convertToUIImage(with: image)
        }
    }
    
    func convertToUIImage(with productImage: Image) {
        guard let imageURL = URL(string: productImage.url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let image = UIImage(data: data!) else { return }
            self.productImages.append(image)
        }.resume()
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
    
    // MARK: - Setup CollectionView Method
    func setupImageCollectionView() {
        imageCollectionView.collectionViewLayout = OpenMarketViewLayout.productImages
        imageCollectionView.delegate = self
        imageCollectionView.decelerationRate = .fast
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.showsHorizontalScrollIndicator = false
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

extension ProductDetailViewController {
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) { action in
            self.performSegue(withIdentifier: "edit", sender: nil)
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.deleteCurrentProduct()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        return alert
    }
    
    func deleteCurrentProduct() {
        guard let productID = productID, let secret = secret else { return }
        apiManager.deleteProduct(id: productID, secret: secret) { result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    print("\(products.name) 삭제 완료")
                    self.navigationController?.popViewController(animated: false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController else { return }
        let destination = navigationController.topViewController as? AddProductViewController
        destination?.isEdit = true
        destination?.images = productImages
        destination?.product = productDetail
    }
    
}
