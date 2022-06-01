//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

fileprivate enum Const {
    static let error = "ERROR"
    static let cancel = "Cancel"
    static let done = "Done"
    static let really = "Really?"
    static let postSuccesse = "Post Successe"
    
}

final class RegistrationViewController: ProductViewController {
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managementType = ManagementType.registration
        setupView()
        setupNavigationItems()
        setupKeyboardNotification()
    }
    
    private func setupView() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddImageButton))
        baseView.addImageView.addGestureRecognizer(gesture)
        
        view = baseView
    }
    
    @objc private func didTapAddImageButton() {
        self.present(self.imagePicker, animated: true)
    }
   
    private func postProduct() {
        let productToRegister = extractData()
        
        self.network.postData(params: productToRegister) { result in
            switch result {
            case .success(_):
                self.showAlert(title: Const.postSuccesse) {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                self.showAlert(title: Const.error, message: error.errorDescription)
            }
        }
    }
}

// MARK: - UIImagePicker

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
       
        guard let pickerImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        let convertedImageView = convertSize(in: pickerImage)
        
        if baseView.imagesStackView.arrangedSubviews.count == 5 {
            baseView.addImageView.isHidden = true
        }
        baseView.imagesStackView.insertArrangedSubview(convertedImageView, at: .zero)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func convertSize(in image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true

        if image.getSize() > 300 {
            imageView.image = image.resize(newWidth: baseView.addImageView.image?.size.width ?? .zero)
        }
        
        imageView.image = image
        return imageView
    }
}

// MARK: - navigationBar

extension RegistrationViewController {
    private func setupNavigationItems() {
        self.navigationItem.title = managementType?.type
        
        let cancelButton = UIBarButtonItem(
            title: Const.cancel,
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton)
        )
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(
            title: Const.done,
            style: .plain,
            target: self,
            action: #selector(didTapDoneButton)
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        self.showAlert(title: Const.really, cancel: Const.cancel, action: postProduct)
    }
}
