import UIKit

class ProductModificationViewController: UIViewController {
    
    typealias Product = ProductDetailQueryManager.Response
    
    private var product: Product?
    
    //MARK: - Initializer
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(product: Product) {
        self.init(nibName: nil, bundle: nil)
        self.product = product
    }
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = ProductEditingView(viewController: self)
        configure()
    }
    
    private func configure() {
        guard let view = view as? ProductEditingView,
              let product = product else {
                  return
              }
        
        configureNavigationBar(at: view)
        view.imageAddingButton.isHidden = true
        configureImageStackView(from: product, at: view)
        configureNameTextField(from: product, at: view)
        configurePriceTextField(from: product, at: view)
        configureCurrencySegmentedControl(from: product, at: view)
        configureBargainPriceTextField(from: product, at: view)
        configureStockTextField(from: product, at: view)
        configureDescriptionTextView(from: product, at: view)
    }
}

//MARK: - NavigationBar
extension ProductModificationViewController {
    
    private func configureNavigationBar(at view: ProductEditingView) {
        view.navigationBar.setLeftButton(title: "Cancel", action: #selector(dismissModal))
        view.navigationBar.setMainLabel(title: "상품수정")
        view.navigationBar.setRightButton(title: "Done", action: #selector(modifyProduct))
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
    
    @objc private func modifyProduct() {
        guard let view = view as? ProductEditingView,
              let product = product else {
                  return
              }
        
        let currency = view.currencySegmentedControl.titleForSegment(at: view.currencySegmentedControl.selectedSegmentIndex)
        NetworkingAPI.ProductModify.request(session: URLSession.shared,
                                            identifier: Vendor.identifier,
                                            productId: product.id,
                                            name: view.nameTextField.text,
                                            descriptions: view.descriptionTextView.text,
                                            thumbnailId: nil,
                                            price: Double(view.priceTextField.text ?? ""),
                                            currency: currency,
                                            discountedPrice: Double(view.bargainPriceTextField.text ?? ""),
                                            stock: Int(view.stockTextField.text ?? ""),
                                            secret: Vendor.secret) {
            result in
            switch result {
            case .success:
                print("Modify success")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - ImageStackView
extension ProductModificationViewController {
    
    private func configureImageStackView(from product: Product, at view: ProductEditingView) {
        for _ in (1...product.images.count) {
            view.addToStackViewAtFirst(imageView: UIImageView())
        }
        
        for (index, image) in product.images.enumerated() {
            ImageLoader.load(from: image.url) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        print(OpenMarketError.conversionFail("Data", "UIImage"))
                        return
                    }
                    DispatchQueue.main.async {
                        view.updateImageOfStackView(image, at: index)
                    }
                case .failure(let error):
                    print(error.description)
                }
            }
        }
    }
}

//MARK: - TextField
extension ProductModificationViewController {
    
    private func configureNameTextField(from product: Product, at view: ProductEditingView) {
        view.nameTextField.text = product.name
    }

    private func configurePriceTextField(from product: Product, at view: ProductEditingView) {
        view.priceTextField.text = String(Int(product.price))
    }
    
    private func configureCurrencySegmentedControl(from product: Product, at view: ProductEditingView){
        let selectedIndex = product.currency == .KRW ? 0 : 1
        view.currencySegmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    private func configureBargainPriceTextField(from product: Product, at view: ProductEditingView){
        view.bargainPriceTextField.text = String(Int(product.bargainPrice))
    }
    
    private func configureStockTextField(from product: Product, at view: ProductEditingView){
        view.stockTextField.text = String(product.stock)
    }
    
    private func configureDescriptionTextView(from product: Product, at view: ProductEditingView){
        view.descriptionTextView.text = product.description
    }
}


