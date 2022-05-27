//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

final class RegistrationViewController: UIViewController {
    private lazy var baseView = ProductRegistrationView(frame: view.frame)
    private let network = URLSessionProvider<ProductList>()
    let imagePicker = UIImagePickerController()
    
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
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didTapAddImageButton() {
        self.present(self.imagePicker, animated: true)
    }
    
    private func setupNavigationItems() {
        self.navigationItem.title = "상품등록"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        let alert = UIAlertController(title: "Really?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.extractData()
            self.dismiss(animated: true)
        }
        let noAction = UIAlertAction(title: "No", style: .destructive)
        alert.addActions(yesAction, noAction)
        present(alert, animated: true)
    }
    
    private func extractData() {
        let name = baseView.productName.text
        let price = Int(baseView.productPrice.text ?? "0")
        let discountedPrice = Int(baseView.productBargenPrice.text ?? "0")
        let currency = (CurrencyType(rawValue: baseView.currencySegmentControl.selectedSegmentIndex) ?? CurrencyType.krw).description
        let stock = Int(baseView.productStock.text ?? "0")
        let description = baseView.productDescription.text
        var images: [Image] = extractImage()
        
        let param = ProductRegistration(
            name: name,
            price: price,
            discountedPrice: discountedPrice,
            currency: currency,
            secret: OpenMarket.secret.discription,
            descriptions: description,
            stock: stock,
            images: images)
        
        self.network.postData(params: param, images: images, completionHandler: { result in
            DispatchQueue.main.async {
                if case .failure(let error) = result {
                    return
                }
            }
        })
    }
    
    func extractImage() -> [Image] {
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
    
    @objc private func keyboardWillHide() {
        view.bounds.origin.y = 0
        baseView.productDescription.contentInset.bottom = 0
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var newImage: UIImage?
        
        if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        let newImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = newImage
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            return imageView
        }()
        
        if baseView.imagesStackView.arrangedSubviews.count == 5 {
            baseView.imageView.isHidden = true
        }
        baseView.imagesStackView.insertArrangedSubview(newImageView, at: .zero)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
