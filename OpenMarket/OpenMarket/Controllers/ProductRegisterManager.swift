import UIKit

protocol PickerPresenter: AnyObject {
    func presentImagePickerView()
}

class ProductRegisterManager {
    weak var delegate: PickerPresenter?
    let productInformationView = ProductInformationView()
    
    init() {
        productInformationView.addImageButton.addTarget(self, action: #selector(didTapAddImageButton), for: .touchUpInside)
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
}
