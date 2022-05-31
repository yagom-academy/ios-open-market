//
//  Asd.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/30.
//

import UIKit

class ProductManagementViewController: UIViewController {
    let network = URLSessionProvider<Product>()
    lazy var baseView = ProductRegistrationView(frame: view.frame)
    var productManagementType: ManagementType?
    
    func extractData() -> ProductRegistration {
        let name = baseView.productName.text
        let price = Int(baseView.productPrice.text ?? "0")
        let discountedPrice = Int(baseView.productDiscountedPrice.text ?? "0")
        let currency = (CurrencyType(rawValue: baseView.currencySegmentControl.selectedSegmentIndex) ?? CurrencyType.krw).description
        let stock = Int(baseView.productStock.text ?? "0")
        let description = baseView.productDescription.text
        let images: [Image] = extractImage()
       
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
    
    private func extractImage() -> [Image] {
        var images: [Image] = []
        let imagePicker = baseView.imagesStackView.arrangedSubviews.last
        imagePicker?.removeFromSuperview()
        
        baseView.imagesStackView.arrangedSubviews.forEach { UIView in
            guard let UIimage = UIView as? UIImageView else {
                return
            }
            
            guard let data = UIimage.image?.jpegData(compressionQuality: 0.1) else {
                return
            }
            
            let image = Image(fileName: "?", type: "?", data: data)
            images.append(image)
        }
        return images
    }
}

// MARK: - Keyboard

extension ProductManagementViewController {
    
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyvoardHieght = keyboardFrame.cgRectValue.height
        
        if baseView.productDescription.isFirstResponder {
            view.bounds.origin.y = 150
            baseView.productDescription.contentInset.bottom = keyvoardHieght - 150
        } else {
            view.bounds.origin.y = 0
            baseView.productDescription.contentInset.bottom = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillHide() {
        view.bounds.origin.y = 0
        baseView.productDescription.contentInset.bottom = 0
    }
}
