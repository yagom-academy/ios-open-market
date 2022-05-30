//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

//protocol Add {}
//
//extension Add {
////    var baseView = ProductRegistrationView(frame: Self.self)
//    let network = URLSessionProvider<ProductList>()
//}

final class RegistrationViewController: UIViewController {
    private lazy var baseView = ProductRegistrationView(frame: view.frame)
    private let network = URLSessionProvider<ProductList>()
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupView()
        setupKeyboardNotification()
    }
    
    private func setupView() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddImageButton))
        baseView.imageView.addGestureRecognizer(gesture)
        
        view = baseView
    }
    
    @objc private func didTapAddImageButton() {
        self.present(self.imagePicker, animated: true)
    }
    
    private func postProduct() {
        let newProduct = extractData()
        self.network.postData(params: newProduct) { result in
            if case .failure(let error) = result {
                self.showAlert(title: "Error", message: error.errorDescription)
            }
        }
    }
    
    private func extractData() -> ProductRegistration {
        let name = baseView.productName.text
        let price = Int(baseView.productPrice.text ?? "0")
        let discountedPrice = Int(baseView.productBargenPrice.text ?? "0")
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

// MARK: - NavigationBar

extension RegistrationViewController {
    private func setupNavigationItems() {
        self.navigationItem.title = "상품등록"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapDoneButton() {
        self.showAlert(title: "Really?", ok: "Yes", cancel: "No", action: postProduct)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - Keyboard

extension RegistrationViewController {
    private func setupKeyboardNotification() {
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

// MARK: - UIImagePicker

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
       
        guard let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let newImageView = convertSize(in: possibleImage)
        
        if baseView.imagesStackView.arrangedSubviews.count == 5 {
            baseView.imageView.isHidden = true
        }
        baseView.imagesStackView.insertArrangedSubview(newImageView, at: .zero)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func convertSize(in image: UIImage) -> UIImageView {
        let newImage = UIImageView()
        newImage.widthAnchor.constraint(equalTo: newImage.heightAnchor).isActive = true

        if image.getSize() > 300 {
            newImage.image = image.resize(newWidth: baseView.imageView.image?.size.width ?? 0)
        }
        
        newImage.image = image
        return newImage
    }
}
