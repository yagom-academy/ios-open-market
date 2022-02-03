import UIKit
import JNomaKit

final class ProductDetailViewController: UIViewController {
    
    enum LayoutAttribute {
        static let largeSpacing: CGFloat = 30
        static let smallSpacing: CGFloat = 10
        
        enum TitleLabel {
            static let fontSize: CGFloat = 17
        }
        
        enum StockLabel {
            static let textStyle: UIFont.TextStyle = .body
            static let stockFontColor: UIColor = .systemGray
            static let soldoutFontColor: UIColor = .orange
        }
        
        enum PriceLabel {
            static let textStyle: UIFont.TextStyle = .body
            static let originalPriceFontColor: UIColor = .red
            static let discountedPriceFontColor: UIColor = .systemGray
        }
        
        enum DescriptionTextView {
            static let textStyle: UIFont.TextStyle = .body
        }
    }
    
    typealias Product = NetworkingAPI.ProductDetailQuery.Response
    
    private var backButtonItem: UIBarButtonItem!
    private var modifyOrDeleteButtonItem: UIBarButtonItem!
    private let acitivityIndicator = UIActivityIndicatorView()
    private let imageScrollView = UIScrollView()
    private let imageStackView = UIStackView()
    private let nameLabel = UILabel()
    private let stockLabel = UILabel()
    private let priceLabel = PriceLabel()
    private let descriptionTextView = UITextView()
    private var product: Product?
    
    var productId: Int?
    
    override func loadView() {
        super.loadView()
        create()
        organizeViewHierarchy()
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProductDetail()
    }
    
    private func create() {
        createBackButtonItem()
        createModifyOrDeleteButtonItem()
    }
    
    private func organizeViewHierarchy() {
        navigationItem.setLeftBarButton(backButtonItem, animated: false)
        navigationItem.setRightBarButton(modifyOrDeleteButtonItem, animated: false)
        
        view.addSubview(acitivityIndicator)
        view.addSubview(imageScrollView)
        view.addSubview(nameLabel)
        view.addSubview(stockLabel)
        view.addSubview(priceLabel)
        view.addSubview(descriptionTextView)
        
        imageScrollView.addSubview(imageStackView)
    }
    
    private func configure() {
        configureMainView()
        configureAcitivityIndicator()
        configureImageScrollView()
        configureImageStackView()
        configureNameLabel()
        configureStockLabel()
        configurePriceLabel()
        configureDescriptionTextView()
    }
    
    private func update() {
        updateNavigationTitle()
        updateImageStackView()
        updateNameLabel()
        updateStockLabel()
        updatePriceLabel()
        updateDescriptionTextView()
    }

    private func configureMainView() {
        view.backgroundColor = .systemBackground
    }
}

//MARK: - BackButtonItem
extension ProductDetailViewController {
    
    private func createBackButtonItem() {
        backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(dismissProductDetailViewController))
    }
    
    @objc private func dismissProductDetailViewController() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - NavigationTitle
extension ProductDetailViewController {
    
    private func updateNavigationTitle() {
        guard let product = product else {
            return
        }
        navigationItem.title = product.name
    }
}

//MARK: - ModificationButtonItem
extension ProductDetailViewController {
    
    private func createModifyOrDeleteButtonItem() {
        modifyOrDeleteButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(presentModifyOrDeleteActionSheet))
    }
    
    @objc private func presentModifyOrDeleteActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction = UIAlertAction(title: "수정", style: .default) {
            _ in
            self.presentModificationViewController()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {
            _ in
            self.presentDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentModificationViewController() {
        guard let product = product else {
            return
        }
        let modificationViewController = ProductModificationViewController(product: product)
        modificationViewController.modalPresentationStyle = .fullScreen
        present(modificationViewController, animated: true)
    }
    
    private func presentDeleteAlert() {
        let alert = UIAlertController(title: "삭제비밀번호입력", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {
            _ in
            guard let inputSecret = alert.textFields?[0].text else {
                return
            }
            self.checkSecretAndDeleteProduct(inputSecret: inputSecret) { result in
                switch result {
                case .success(let secret):
                    self.deleteProduct(secret: secret)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print(error.description)
                }
            }
        }
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
    }
    
    private func checkSecretAndDeleteProduct(inputSecret: String, completion: @escaping (Result<String, OpenMarketError>) -> Void) {
        guard let productId = productId else {
            return
        }

        NetworkingAPI.ProductDeleteSecretQuery.request(session: URLSession.shared,
                                                       productId: productId,
                                                       identifier: Vendor.identifier,
                                                       secret: Vendor.secret) {
            (result) in
            switch result {
            case .success(let data):
                let secret = String(decoding: data, as: UTF8.self)
                if inputSecret == secret {
                    completion(.success(secret))
                } else {
                    completion(.failure(OpenMarketError.inputSecretIsWrong(secret)))
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    private func deleteProduct(secret: String) {
        guard let productId = productId else {
            return
        }
        
        NetworkingAPI.ProductDelete.request(session: URLSession.shared,
                                            identifier: Vendor.identifier,
                                            productId: productId,
                                            productSecret: secret) {
            result in
            switch result {
            case .success:
                print("Delete Success")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

//MARK: - AcitivityIndicator
extension ProductDetailViewController {
    
    private func configureAcitivityIndicator() {
        acitivityIndicator.startAnimating()
        acitivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acitivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acitivityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor),
            acitivityIndicator.heightAnchor.constraint(equalTo: acitivityIndicator.widthAnchor,
                                                      constant: -2 * LayoutAttribute.largeSpacing),
            acitivityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}

//MARK: - ImageScrollView
extension ProductDetailViewController {
    
    private func configureImageScrollView() {
        imageScrollView.isPagingEnabled = true
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: imageScrollView.widthAnchor,
                                                    constant: -2 * LayoutAttribute.largeSpacing),
            imageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}

//MARK: - ImageStackView
extension ProductDetailViewController {
    
    private func configureImageStackView() {
        imageStackView.axis = .horizontal
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageStackView.heightAnchor.constraint(equalTo: view.widthAnchor),
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
        ])
    }
    
    private func updateImageStackView() {
        guard let product = product else {
            return
        }
        
        product.images.forEach {
            ImageLoader.load(from: $0.url) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.sync {
                        guard let image = UIImage(data: data) else {
                            print(OpenMarketError.conversionFail("data", "UIImage"))
                            return
                        }
                        self.addToStack(image: image)
                        self.acitivityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func addToStack(image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0,
                                                                     left: -1 * LayoutAttribute.largeSpacing,
                                                                     bottom: 0,
                                                                     right: -1 * LayoutAttribute.largeSpacing))
        imageStackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageStackView.heightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageStackView.heightAnchor)
        ])
    }
}

//MARK: - NameLabel
extension ProductDetailViewController {
    
    private func configureNameLabel() {
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor,
                                                   constant: LayoutAttribute.smallSpacing),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                       constant: LayoutAttribute.largeSpacing)
        ])
    }
    
    private func updateNameLabel() {
        guard let product = product else {
            return
        }
        
        nameLabel.attributedText = JNAttributedStringMaker.attributedString(
            text: product.name,
            textStyle: .body,
            fontColor: .black,
            attributes: [.bold]
        )
    }
}

//MARK: - StockLabel
extension ProductDetailViewController {
    
    private func configureStockLabel() {
        stockLabel.font = .preferredFont(forTextStyle: LayoutAttribute.StockLabel.textStyle)
        stockLabel.adjustsFontForContentSizeCategory = true
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stockLabel.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor,
                                                   constant: LayoutAttribute.smallSpacing),
            stockLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                        constant: -1 * LayoutAttribute.largeSpacing)
        ])
    }
    
    private func updateStockLabel() {
        guard let product = product else {
            return
        }
        
        if product.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = LayoutAttribute.StockLabel.soldoutFontColor
        } else {
            stockLabel.text = "잔여수량: \(product.stock)"
            stockLabel.textColor = LayoutAttribute.StockLabel.stockFontColor
        }
    }
}

//MARK: - PriceLabel
extension ProductDetailViewController {
    
    private func configurePriceLabel() {
        priceLabel.numberOfLines = 0
        priceLabel.adjustsFontForContentSizeCategory = true
        priceLabel.textAlignment = .right
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor,
                                                   constant: LayoutAttribute.smallSpacing),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                        constant: -1 * LayoutAttribute.largeSpacing)
        ])
    }
    
    private func updatePriceLabel() {
        guard let product = product else {
            return
        }
        
        priceLabel.setText(
            currency: product.currency.rawValue,
            originalPrice: product.price,
            discountedPrice: product.discountedPrice,
            direction: .vertical
        )
    }
}

//MARK: - DescriptionTextView
extension ProductDetailViewController {
    
    private func configureDescriptionTextView() {
        descriptionTextView.font = .preferredFont(forTextStyle: LayoutAttribute.DescriptionTextView.textStyle)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor,
                                                            constant: LayoutAttribute.smallSpacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                                constant: LayoutAttribute.largeSpacing),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                constant: -1 * LayoutAttribute.largeSpacing),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func updateDescriptionTextView() {
        guard let product = product else {
            return
        }
        
        descriptionTextView.text = product.description
    }
}

//MARK: - Networking
extension ProductDetailViewController {

    private func fetchProductDetail() {
        guard let productId = productId else {
            return
        }
        
        NetworkingAPI.ProductDetailQuery.request(session: URLSession.shared,
                                                 productId: productId) {
            result in
            switch result {
            case .success(let data):
                guard let product = NetworkingAPI.ProductDetailQuery.decode(data: data) else {
                    print(OpenMarketError.decodingFail("Data", "etworkingAPI.ProductDetailQuery.Response"))
                    return
                }
                self.product = product
                DispatchQueue.main.async {
                    self.update()
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
