import UIKit

protocol PickerPresenter: AnyObject {
    func presentImagePickerView()
}

class ProductRegisterManager {
    weak var delegate: PickerPresenter?
    let productInformationView = ProductInformationView()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAddImageButton), name: .imageRemoved, object: nil)
        productInformationView.addImageButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
    }
    
    @objc private func showAddImageButton() {
       setImageButtonHidden(state: false)
    }
    
    @objc private func didTapAddImageButton() {
        delegate?.presentImagePickerView()
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
    
    func addImageToImageStackView(from image: UIImage) {
        let width = productInformationView.addImageButton.frame.width
        let height = productInformationView.addImageButton.frame.height
        guard let resizedImage = image.resizeImageTo(size: CGSize(width: width, height: height)) else {
            return
        }
        
        let productImageCustomView = ProductImageCustomView()
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
        return productInformationView.imageStackView.arrangedSubviews
            .filter { $0 is ProductImageCustomView }
            .compactMap { $0 as? ProductImageCustomView }
            .compactMap { $0.productImageView.image }
            .compactMap { $0.pngData() }
            .map { ImageData(fileName: "\(UUID().uuidString).png", data: $0, type: .png) }
    }
    
    private func createProductRegisterInformation() -> ProductRegisterInformation {
        let secret = "R_WGJGz8CV^aa_V!"
        let name = productInformationView.nameTextField.text ?? ""
        let descriptions = productInformationView.descriptionTextView.text ?? ""
        let priceString = productInformationView.priceTextField.text ?? ""
        let price = Double(priceString) ?? 0
        let currency = takeCurrentCurrency()
        let discountedPriceString = productInformationView.discountedPriceTextField.text ?? ""
        let discountedPrice = Double(discountedPriceString) ?? 0
        let stockString = productInformationView.stockTextField.text ?? ""
        let stock = Int(stockString) ?? 0
        
        return ProductRegisterInformation(name: name, descriptions: descriptions, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock, secret: secret)
    }
    
    func register() {
        let productRegisterInformation = createProductRegisterInformation()
        let api = APIService()
        let imagesDatas = takeRegisteredImages()
        
        api.registerProduct(newProduct: productRegisterInformation, images: imagesDatas) { result in
            switch result {
            case .failure(let error):
                print(error)
            default:
                return
            }
        }
    }
    
    func updateProductData() {
        NotificationCenter.default.post(name: .updateProductData, object: nil)
    }
}
