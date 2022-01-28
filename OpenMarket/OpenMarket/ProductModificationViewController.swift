import UIKit

class ProductModificationViewController: ProductRegistrationViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reInitializeForModification()
    }
    
    //MARK: - Private Method
    private func reInitializeForModification() {
        guard let product = product else {
            return
        }
        
        reInitializeNavigationBar()
        reInitializeImageStackView(from: product)
        imageAddingButton.isHidden = true
        reInitializeNameTextField(from: product)
        reInitializePriceTextField(from: product)
        reInitializeCurrencySegmentedControl(from: product)
        reInitializeBargainPriceTextField(from: product)
        reInitializeStockTextField(from: product)
        reInitializeDescriptionTextView(from: product)
    }
}

//MARK: - Private Method
extension ProductModificationViewController {
    
    private func reInitializeNavigationBar() {
        navigationBar.setMainLabel(title: "상품수정")
        navigationBar.setRightButton(title: "Done", action: #selector(modifyProduct))
    }
    
    @objc private func modifyProduct() {
        guard let product = product else {
            return
        }
        
        let currency = currencySegmentedControl.titleForSegment(at: currencySegmentedControl.selectedSegmentIndex)
        NetworkingAPI.ProductModify.request(session: URLSession.shared,
                                            identifier: Vendor.identifier,
                                            productId: product.id,
                                            name: nameTextField.text,
                                            descriptions: descriptionTextView.text,
                                            thumbnailId: nil,
                                            price: Double(priceTextField.text ?? ""),
                                            currency: currency,
                                            discountedPrice: Double(bargainPriceTextField.text ?? ""),
                                            stock: Int(stockTextField.text ?? ""),
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

    private func reInitializeImageStackView(from product: Product) {
        product.images.forEach {
            ImageLoader.load(from: $0.url) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        print(OpenMarketError.conversionFail("Data", "UIImage"))
                        return
                    }
                    DispatchQueue.main.sync {
                        self.addToStack(image: image)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func reInitializeNameTextField(from product: Product) {
        nameTextField.text = product.name
    }
    private func reInitializePriceTextField(from product: Product) {
        priceTextField.text = String(Int(product.price))
    }
    private func reInitializeCurrencySegmentedControl(from product: Product){
        let selectedIndex = product.currency == .KRW ? 0 : 1
        currencySegmentedControl.selectedSegmentIndex = selectedIndex
    }
    private func reInitializeBargainPriceTextField(from product: Product){
        bargainPriceTextField.text = String(Int(product.bargainPrice))
    }
    private func reInitializeStockTextField(from product: Product){
        stockTextField.text = String(product.stock)
    }
    private func reInitializeDescriptionTextView(from product: Product){
        descriptionTextView.text = product.description
    }
}


