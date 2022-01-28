import UIKit

class ProductDetailViewController: UIViewController {
    static let storyboardName = "ProductDetail"
    private var product: Product?
    private var productId: Int?
    private var networkTask: NetworkTask?
    private var jsonParser: JSONParser?
    private var imageIndex: CGFloat = 0.0
    
    private var imageIndexText: String {
        let pageNumber = Int(imageIndex + 1)
        let imagesCount = product?.images?.count ?? 0
        return "\(pageNumber)/\(imagesCount)"
    }
    
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    @IBOutlet private weak var imageIndexLabel: UILabel!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    convenience init?(
        coder: NSCoder,
        productId: Int,
        networkTask: NetworkTask,
        jsonParser: JSONParser
    ) {
        self.init(coder: coder)
        self.productId = productId
        self.networkTask = networkTask
        self.jsonParser = jsonParser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupImagesCollectionView()
    }
    
    private func loadData() {
        guard let productId = productId else { return }
        networkTask?.requestProductDetail(productId: productId) { result in
            switch result {
            case .success(let data):
                self.product = try? self.jsonParser?.decode(from: data)
                DispatchQueue.main.async {
                    self.setupViewElements()
                    self.setupNavigationBar()
                }
            case.failure(let error):
                self.showAlert(title: "데이터를 불러오지 못했습니다", message: error.localizedDescription)
            }
        }
    }
    
    private func setupViewElements() {
        productNameLabel.attributedText = product?.attributedTitle
        stockLabel.attributedText = product?.attributedStock
        priceLabel.attributedText = product?.attributedPrice
        descriptionTextView.text = product?.description
        imageIndexLabel.text = imageIndexText
        imagesCollectionView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = product?.name
        if product?.vendorId == 16 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .plain,
                target: self,
                action: nil
            )
        }
    }
    
    private func setupImagesCollectionView() {
        imagesCollectionView.dataSource = self
        let scrollView = imagesCollectionView as UIScrollView
        scrollView.delegate = self
        scrollView.decelerationRate = .fast
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: view.frame.width - 20,
            height: view.frame.width - 20
        )
        flowLayout.scrollDirection = .horizontal
        imagesCollectionView.collectionViewLayout = flowLayout
    }
    
    private func makeImageView(with image: UIImage?, frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func changePageOffset(of targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = round(offset.x / cellWidthIncludingSpacing)
        if index > imageIndex {
            imageIndex += 1
        } else if index < imageIndex, imageIndex != 0 {
            imageIndex -= 1
        }
        offset = CGPoint(x: imageIndex * cellWidthIncludingSpacing, y: 0)
        targetContentOffset.pointee = offset
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return product?.images?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UICollectionViewCell.identifier,
            for: indexPath
        )
        cell.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        let urlString = product?.images?[indexPath.item].url ?? ""
        guard let url = URL(string: urlString) else {
            return cell
        }
        networkTask?.downloadImage(from: url) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    let imageView = self.makeImageView(
                        with: image,
                        frame: cell.contentView.bounds
                    )
                    guard indexPath == collectionView.indexPath(for: cell) else { return }
                    cell.contentView.addSubview(imageView)
                }
            case .failure:
                let image = UIImage(systemName: "xmark.app")
                let imageView = self.makeImageView(
                    with: image,
                    frame: cell.contentView.bounds
                )
                DispatchQueue.main.async {
                    guard indexPath == collectionView.indexPath(for: cell) else { return }
                    cell.contentView.addSubview(imageView)
                }
            }
        }
        return cell
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        changePageOffset(of: targetContentOffset)
        imageIndexLabel.text = imageIndexText
    }
}
