import UIKit

class ProductRegisterManager {
    weak var pickerPresenterDelegate: PickerPresenter?
    let productInformationScrollView = ProductInformationScrollView()
    private lazy var productInformationView = productInformationScrollView.productInformationView
    private let api = APIService()
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAddImageButton), name: .imageRemoved, object: nil)
        productInformationView.addImageButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
    }
    
    @objc private func showAddImageButton() {
       setImageButtonHidden(state: false)
    }
    
    @objc private func didTapAddImageButton() {
        pickerPresenterDelegate?.presentImagePickerView()
    }
    
    var isRegisteredImageEmpty: Bool {
        return takeRegisteredImageCounts() == 0
    }
    
    var isPriceTextFieldEmpty: Bool {
        return productInformationView.priceTextField.text?.isEmpty ?? true
    }
    
    func takeRegisteredImageCounts() -> Int {
        let images = productInformationView.imageStackView.arrangedSubviews.filter { view in
            view is ProductImageCustomView
        }
        return images.count
    }
    
    func setImageButtonHidden(state: Bool) {
        productInformationView.addImageButton.isHidden = state
    }
    
    func takeNameTextFieldLength() -> Int {
        guard let text = productInformationView.nameTextField.text else {
            return 0
        }
    
        return text.count
    }
    
    func taksdescriptionTextLength() -> Int {
        guard let text = productInformationView.descriptionTextView.text else {
            return 0
        }
        
        return text.count
    }
    
    func checkValidDiscount() -> Bool {
        guard let priceText = productInformationView.priceTextField.text,
              let price = Double(priceText) else {
            return false
        }
        
        let discountedPriceText = productInformationView.discountedPriceTextField.text ?? "0"
        let discountedPrice = Double(discountedPriceText) ?? 0
        
        return price >= discountedPrice
    }
    
    func addImageToImageStackView(from image: UIImage, hasDeleteButton: Bool) {
        let width: CGFloat = RegisteredImageSize.width
        let height: CGFloat = RegisteredImageSize.height
        guard let resizedImage = image.resizeImageTo(size: CGSize(width: width, height: height)) else {
            return
        }
        
        let productImageCustomView = ProductImageCustomView()
        
        if !hasDeleteButton {
            productImageCustomView.setDeleteButtonHidden(state: true)
        }
        
        productImageCustomView.fetchImage(with: resizedImage)
        productInformationView.imageStackView.addArrangedSubview(productImageCustomView)
    }
    
    func addDelegateToTextField(delegate: UITextFieldDelegate) {
        [productInformationView.nameTextField, productInformationView.priceTextField, productInformationView.discountedPriceTextField, productInformationView.stockTextField].forEach { textField in
            textField.delegate = delegate
        }
    }
    
    func addDelegateToTextView(delegate: UITextViewDelegate) {
        productInformationView.descriptionTextView.delegate = delegate
    }
    
    private func takeCurrentCurrency() -> Currency {
        return productInformationView.currencySegmentedControl.selectedSegmentIndex == 0 ? .krw : .usd
    }
    
    private func takeRegisteredImages() -> [ImageData] {
        let productImageCustomView = productInformationView.imageStackView.arrangedSubviews
            .filter { view in
                view is ProductImageCustomView
            }.compactMap { view in
                view as? ProductImageCustomView
            }
        
        let imageData = productImageCustomView
            .compactMap { view in
                view.productImageView.image
            }.compactMap { image in
                image.pngData()
            }.map { data in
                ImageData(fileName: "\(UUID().uuidString).png", data: data, type: .png)
            }
        
        return imageData
    }
    
    private func createProductRegisterInformation() -> ProductRegisterInformation {
        let name = productInformationView.nameTextField.text ?? ""
        let descriptions = productInformationView.descriptionTextView.text ?? ""
        let priceString = productInformationView.priceTextField.text ?? ""
        let price = Double(priceString) ?? 0
        let currency = takeCurrentCurrency()
        let discountedPriceString = productInformationView.discountedPriceTextField.text ?? ""
        let discountedPrice = Double(discountedPriceString) ?? 0
        let stockString = productInformationView.stockTextField.text ?? ""
        let stock = Int(stockString) ?? 0
        
        let productRegisterInformation = ProductRegisterInformation(name: name, descriptions: descriptions, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock, secret: UserInformation.secret)
        
        return productRegisterInformation
    }
    
    func fetchRegisteredProductDetail(from productDetail: ProductDetail) {
        if let productImages = productDetail.images {
            productImages.forEach { productImage in
                guard let image = ImageLoader.loadImage(from: productImage.url) else {
                    return
                }
                addImageToImageStackView(from: image, hasDeleteButton: false)
            }
        }
        
        setImageButtonHidden(state: true)
        
        productInformationView.nameTextField.text = productDetail.name
        productInformationView.descriptionTextView.text = productDetail.description
        productInformationView.priceTextField.text = "\(productDetail.price)"
        productInformationView.currencySegmentedControl.selectedSegmentIndex = productDetail.currency == .krw ? 0 : 1
        productInformationView.discountedPriceTextField.text = "\(productDetail.discountedPrice)"
        productInformationView.stockTextField.text = "\(productDetail.stock)"
    }
    
    func register() {
        let productRegisterInformation = createProductRegisterInformation()
        let imagesDatas = takeRegisteredImages()
        
        api.registerProduct(newProduct: productRegisterInformation, images: imagesDatas) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.updateProductData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func update(productId: Int) {
        let productRegisterInformation = createProductRegisterInformation()
        
        api.updateProduct(productId: productId, modifiedProduct: productRegisterInformation) { result in
            switch result {
            case .success(let modifiedData):
                DispatchQueue.main.async {
                    self.updateProductDetail(with: modifiedData)
                    self.updateProductData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateProductData() {
        NotificationCenter.default.post(name: .updateProductData, object: nil)
    }
    
    private func updateProductDetail(with data: ProductDetail) {
        NotificationCenter.default.post(name: .modifyProductDetail, object: nil, userInfo: [NotificationKey.detail: data])
    }
}
