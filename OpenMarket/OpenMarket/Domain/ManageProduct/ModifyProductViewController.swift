import UIKit

class ModifyProductViewController: ManageProductViewController {
    private let productService = ProductService()
    private var productIdentification: Int?

    init(productIdentification: Int?) {
        self.productIdentification = productIdentification
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        fetchProduct()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Navigation Bar Configuration
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.title = "상품 수정"
    }

    @objc override func touchUpDoneButton() {
    }

    func configureContent(product: Product) {
    }
}

// MARK: Networking
extension ModifyProductViewController {
    func fetchProduct() {
        guard let productIdentification = productIdentification else {
            return
        }
        productService.retrieveProduct(
            productIdentification: productIdentification,
            session: HTTPUtility.defaultSession) { result in
                switch result {
                case .success(let product):
                    DispatchQueue.main.async {
                        self.configureContent(product: product)
                    }
                case .failure:
                    return
                }
            }
    }
}
