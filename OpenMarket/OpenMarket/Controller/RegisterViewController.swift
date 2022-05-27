//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/25.
//

import UIKit

final class RegisterViewController: RegisterEditBaseViewController {
    
    private let picker = UIImagePickerController()
    private let productListUseCase = ProductListUseCase()
    
    private lazy var addImageButton: UIButton = {
        let imageButton = UIButton()
        let image = UIImage(systemName: "plus")
        imageButton.setImage(image, for: .normal)
        imageButton.backgroundColor = .systemGray5
        imageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)

        return imageButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setBaseImage()
    }
}

// MARK: - Method
extension RegisterViewController {
    func addImageToStackView(image: UIImage){
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        imageView.image = image
        addImageHorizontalStackView.addLastBehind(view: imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: addImageHorizontalStackView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        addImageHorizontalStackView.setNeedsDisplay()
    }
    
    func setBaseImage() {
        addImageHorizontalStackView.addArrangedSubview(addImageButton)
    
        NSLayoutConstraint.activate([
            addImageButton.heightAnchor.constraint(equalTo: addImageHorizontalStackView.heightAnchor),
            addImageButton.widthAnchor.constraint(equalTo: addImageButton.heightAnchor)
        ])
    }
    
    func wrapperRegistrationParameter() -> RegistrationParameter? {
        guard let name = nameTextField.text, name.count >= 3 else {
            //알랏 띄워주기
            return nil
        }
        guard let descriptions = textView.text, descriptions.count < 1000 else {
            return nil
        }
        guard let price = Double(priceTextField.text ?? "0"), price >= 0 else {
            return nil
        }
        guard let selectedText = currencySegmentedControl.titleForSegment(at: currencySegmentedControl.selectedSegmentIndex), let currency = Currency(rawValue: selectedText) else {
            return nil
        }
        guard let discountedPrice = Double(discountPriceTextField.text ?? "0"), discountedPrice >= 0 else {
            return nil
        }
        guard let stock = Int(stockTextField.text ?? "0"), stock >= 0 else {
            return nil
        }
        let secret = Secret.registerSecret
        
        return RegistrationParameter(name: name, descriptions: descriptions, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock, secret: secret)
    }
    
    func wrapperImage() -> [UIImage] {
        var imageArray = [UIImage]()
        
        for subView in addImageHorizontalStackView.arrangedSubviews {
            if let subView = subView as? UIImageView, let uiImage = subView.image?.resized(to: CGSize(width: 10, height: 10)) {
                imageArray.append(uiImage)
            }
        }
        return imageArray
    }
    
    @objc override func registerEditViewRightBarButtonTapped() {
        guard let registrationParameter = wrapperRegistrationParameter() else {
            return
        }
        productListUseCase.registerProduct(registrationParameter: registrationParameter, images: wrapperImage()) {
            print("성공")
        } registerErrorHandler: { error in
            print(error.localizedDescription)
        }
    }
}

// MARK: - Action Method
extension RegisterViewController {
    
    @objc private func addImage() {
        let alert = UIAlertController(
            title: "상품 이미지 추가",
            message: "",
            preferredStyle: .actionSheet
        )
        let library = UIAlertAction(
            title: "사진앨범",
            style: .default
        ) { (action) in
            self.openLibrary()
        }
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil
        )
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("error")
    }
    addImageToStackView(image: selectedImage)
    picker.dismiss(animated: true)
    }
    
    private func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
}


