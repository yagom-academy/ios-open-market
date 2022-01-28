import UIKit

final class ProductDetailViewController: UIViewController {
    private let productDetailScrollView = ProductDetailScrollView()
    private var productDetail: ProductDetail
    private let apiService = APIService()
    
    init(productDetail: ProductDetail) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드 안써서 fatalError를 줬습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailScrollView.productImageScrollView.delegate = self
        configUI()
        fetchProductDetail(with: productDetail)
        addUpdatedDetailNotification()
    }
    
    private func configUI() {
        configNavigationBar()
        view.backgroundColor = .white
        self.view.addSubview(productDetailScrollView)
        productDetailScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productDetailScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productDetailScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productDetailScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            productDetailScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    private func addUpdatedDetailNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveModifiedProductDetail), name: .modifyProductDetail, object: nil)
    }
    
    @objc private func receiveModifiedProductDetail(_ notification: Notification) {
        if let modifiedProductDetail = notification.userInfo?[NotificationKey.detail] as? ProductDetail {
            fetchProductDetail(with: modifiedProductDetail)
            productDetail = modifiedProductDetail
        }
    }
    
    private func fetchProductDetail(with productDetail: ProductDetail) {
        self.navigationItem.title = productDetail.name
        productDetailScrollView.productNameLabel.text = productDetail.name
        productDetailScrollView.productStockLabel.attributedText = AttributedTextCreator.createStockText(product: productDetail)
        
        guard let price = productDetail.price.formattedToDecimal,
              let bargainPrice = productDetail.bargainPrice.formattedToDecimal else {
            return
        }
        
        if productDetail.discountedPrice.isZero {
            productDetailScrollView.productPriceLabel.isHidden = true
        } else {
            productDetailScrollView.productPriceLabel.isHidden = false
            productDetailScrollView.productPriceLabel.attributedText = NSMutableAttributedString.strikeThroughStyle(string: "\(productDetail.currency.unit) \(price)")
        }
        
        productDetailScrollView.productBargainPriceLabel.attributedText = NSMutableAttributedString.normalStyle(string: "\(productDetail.currency.unit) \(bargainPrice)")
        productDetailScrollView.productDescriptionTextView.text = productDetail.description
        addProductImageView(from: productDetail.images)
    }
    
    private func addProductImageView(from images: [ProductImage]?) {
        guard let images = images else {
            return
        }
        
        let imageWidth = view.frame.width
        
        for index in 0..<images.count {
            let imageView = UIImageView()
            let xPosition = imageWidth * CGFloat(index)
            ImageLoader.loadImage(from: images[index].url) { image in
                let resizedImage = image.resizeImageTo(size: CGSize(width: imageWidth, height: ProductDetailImageSize.height))
                imageView.image = resizedImage
            }
            imageView.frame = CGRect(x: xPosition, y: 0, width: imageWidth, height: ProductDetailImageSize.height)
            imageView.contentMode = .scaleAspectFit
            productDetailScrollView.productImageScrollView.addSubview(imageView)
        }
        
        productDetailScrollView.productImageScrollView.contentSize.width = CGFloat(images.count) * imageWidth
        productDetailScrollView.productImagePageLabel.text = "1/\(Int(productDetailScrollView.productImageScrollView.contentSize.width / imageWidth))"
    }
}

// MARK: - NavigationBar Configuration

private extension ProductDetailViewController {
    func configNavigationBar() {
        let manageButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapManageButton))
        
        if VendorInformation.name == productDetail.vendors?.name {
            self.navigationItem.setRightBarButton(manageButton, animated: true)
            return
        }
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    @objc func didTapManageButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: AlertActionMessage.modify.title, style: .default) { _ in
            self.presentModifyView()
        }
        let deleteAction = UIAlertAction(title: AlertActionMessage.delete.title, style: .destructive) { _ in
            self.presentReceivePasswordAlert()
        }
        let cancelAction = UIAlertAction(title: AlertActionMessage.cancel.title, style: .cancel, handler: nil)
        
        [modifyAction, deleteAction, cancelAction].forEach { action in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentModifyView() {
        let productModifyViewController = UINavigationController(rootViewController: ProductModifyViewController(productDetail: productDetail))
        productModifyViewController.modalPresentationStyle = .fullScreen
        self.present(productModifyViewController, animated: true, completion: nil)
    }
    
    func presentReceivePasswordAlert() {
        let alert = UIAlertController(title: AlertMessage.deleteProduct.title, message: AlertMessage.deleteProduct.message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AlertActionMessage.cancel.title, style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: AlertActionMessage.done.title, style: .default) { _ in
            self.fetchProductPassword(from: alert.textFields?.first?.text) { result in
                switch result {
                case .success(let password):
                    self.deleteProduct(productId: self.productDetail.id, secret: password)
                case .failure(let error):
                    print(error)
                }
            }
        }
        alert.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "비밀번호를 입력해주세요."
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Delete Product

extension ProductDetailViewController {
    private func fetchProductPassword(from password: String?, completion: @escaping (Result<String, APIError>) -> Void) {
        guard let password = password else {
            return
        }
        let productPassword = ProductPassword(secret: VendorInformation.secret)
        apiService.retrieveProductSecret(productId: productDetail.id, password: productPassword) { result in
            switch result {
            case .success(let secret):
                DispatchQueue.main.async {
                    if secret == password {
                        completion(.success(secret))
                        return
                    }
                    self.presentDeleteResponseAlert(isSuccess: false)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func deleteProduct(productId: Int, secret: String) {
        apiService.deleteProduct(productId: productId, secret: secret) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.presentDeleteResponseAlert(isSuccess: true)
                    NotificationCenter.default.post(name: .updateProductData, object: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func presentDeleteResponseAlert(isSuccess: Bool) {
        var alert: UIAlertController
        var confirmAction: UIAlertAction
        if isSuccess {
            alert = UIAlertController(title: AlertMessage.deleteSuccess.title, message: AlertMessage.deleteSuccess.message, preferredStyle: .alert)
            confirmAction = UIAlertAction(title: AlertActionMessage.done.title, style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            alert = UIAlertController(title: AlertMessage.deleteFailure.title, message: AlertMessage.deleteFailure.message, preferredStyle: .alert)
            confirmAction = UIAlertAction(title: AlertActionMessage.done.title, style: .default, handler: nil)
        }
        
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - ScrollView Delegate

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentMaxWidth = Int(productDetailScrollView.productImageScrollView.contentSize.width)
        let imageWidth = Int(view.frame.width)
        let currentXPosition = Int(productDetailScrollView.productImageScrollView.contentOffset.x)
        let currentPage = (currentXPosition / imageWidth) + 1
        let totalPage = Int(contentMaxWidth / imageWidth)
        productDetailScrollView.productImagePageLabel.text = "\(currentPage)/\(totalPage)"
    }
}
