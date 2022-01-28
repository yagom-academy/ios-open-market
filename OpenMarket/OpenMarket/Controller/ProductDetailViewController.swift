import UIKit

class ProductDetailViewController: UIViewController {
    static let storyboardName = "ProductDetail"
    private let password = "password"
    private var product: Product?
    private var productId: Int?
    private var networkTask: NetworkTask?
    private var jsonParser: JSONParser?
    private var imageIndex: CGFloat = 0.0
    private var completionHandler: (() -> Void)?
    
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
        jsonParser: JSONParser,
        completionHandler: (() -> Void)?
    ) {
        self.init(coder: coder)
        self.productId = productId
        self.networkTask = networkTask
        self.jsonParser = jsonParser
        self.completionHandler = completionHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupImagesCollectionView()
    }
    
    private func presentEditView() {
        guard let productId = productId,
              let networkTask = networkTask,
              let jsonParser = jsonParser else { return }
        networkTask.requestProductDetail(productId: productId) { result in
            switch result {
            case .success(let data):
                guard let product: Product = try? jsonParser.decode(from: data) else {
                    return
                }
                let storyboard = UIStoryboard(
                    name: ProductRegistrationViewController.storyboardName,
                    bundle: nil
                )
                DispatchQueue.main.async {
                    let viewController = storyboard.instantiateViewController(
                        identifier: ProductRegistrationViewController.identifier
                    ) { coder in
                        let productRegistrationViewController = ProductRegistrationViewController(
                            coder: coder,
                            isModifying: true,
                            productInformation: product,
                            networkTask: networkTask,
                            jsonParser: jsonParser
                        ) {
                            self.showAlert(title: "수정 성공", message: nil)
                            self.loadData()
                        }
                        return productRegistrationViewController
                    }
                    let navigationController = UINavigationController(
                        rootViewController: viewController
                    )
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(
                    title: "데이터를 불러오지 못했습니다",
                    message: error.localizedDescription
                )
            }
        }
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
                    self.imagesCollectionView.reloadData()
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
    }
    
    private func setupNavigationBar() {
        navigationItem.title = product?.name
        if product?.vendorId == 16 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "square.and.pencil"),
                style: .plain,
                target: self,
                action: #selector(showActionSheet)
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
    
    private func removeProduct() {
        guard let productId = productId else { return }
        networkTask?.requestProductSecret(
            productId: productId,
            identifier: NetworkTask.identifier,
            secret: NetworkTask.secret) { result in
                switch result {
                case .success(let data):
                    let productSecret = String(decoding: data, as: UTF8.self)
                    print(productSecret)
                    self.networkTask?.requestRemoveProduct(
                        identifier: NetworkTask.identifier,
                        productId: productId,
                        productSecret: productSecret
                    ) { result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                                self.completionHandler?()
                            }
                        case .failure(let error):
                            self.showAlert(title: "삭제 실패", message: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.showAlert(title: "상품 시크릿 요청 실패", message: error.localizedDescription)
                }
            }
    }
    
    @objc private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.presentEditView()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let alert = UIAlertController(
                title: "암호를 입력해주세요",
                message: nil,
                preferredStyle: .alert
            )
            let doneAction = UIAlertAction(title: "완료", style: .default) { _ in
                if alert.textFields?[0].text == self.password {
                    self.removeProduct()
                } else {
                    self.showAlert(title: "암호를 다시 확인해주세요", message: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addTextField { textField in
                textField.placeholder = "암호"
                textField.textContentType = .password
                textField.isSecureTextEntry = true
            }
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
