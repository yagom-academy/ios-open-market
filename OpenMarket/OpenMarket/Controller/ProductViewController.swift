//
//  Asd.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/30.
//

import UIKit

fileprivate enum Const {
    static let zero = "0"
    static let empty = ""
}

class ProductViewController: UIViewController {
    let network = URLSessionProvider<DetailProduct>()
    lazy var baseView = ManagementView(frame: view.frame)
    var managementType: ManagementType?
    
    func extractData() -> ProductRegistration {
        let name = baseView.nameTextField.text
        let price = Int(baseView.priceTextField.text ?? Const.zero)
        let discountedPrice = Int(baseView.discountedPriceTextField.text ?? Const.zero)
        let currency = (CurrencyType(rawValue: baseView.segmentControl.selectedSegmentIndex) ?? CurrencyType.krw).description
        let stock = Int(baseView.stockTextField.text ?? Const.zero)
        let description = baseView.descriptionTextView.text
        let images: [ImageFile] = extractImage()
       
        let param = ProductRegistration(
            name: name,
            price: price,
            discountedPrice: discountedPrice,
            currency: currency,
            secret: OpenMarket.secret.description,
            descriptions: description,
            stock: stock,
            images: images)
        
        return param
    }
    
    private func extractImage() -> [ImageFile] {
        var images: [ImageFile] = []
        let imagePicker = baseView.imagesStackView.arrangedSubviews.last
        imagePicker?.removeFromSuperview()
        
        baseView.imagesStackView.arrangedSubviews.forEach { UIView in
            guard let UIimage = UIView as? UIImageView else {
                return
            }
            
            guard let data = UIimage.image?.jpegData(compressionQuality: 0.1) else {
                return
            }
            
            let image = ImageFile(fileName: Const.empty, type: Const.empty, data: data)
            images.append(image)
        }
        return images
    }
}

// MARK: - Keyboard

extension ProductViewController {
    
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyvoardHieght = keyboardFrame.cgRectValue.height
        
        if baseView.descriptionTextView.isFirstResponder {
            view.bounds.origin.y = 150
            baseView.descriptionTextView.contentInset.bottom = keyvoardHieght - 150
        } else {
            view.bounds.origin.y = 0
            baseView.descriptionTextView.contentInset.bottom = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillHide() {
        view.bounds.origin.y = 0
        baseView.descriptionTextView.contentInset.bottom = 0
    }
}
