//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

final class RegistrationViewController: ProductManagementViewController {
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productManagementType = ManagementType.Registration
        setupView()
        setupNavigationItems()
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
            switch result {
            case .success(_):
                self.showAlert(title: "post 성공") {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.errorDescription)
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

// MARK: - navigationBar

extension RegistrationViewController {
    private func setupNavigationItems() {
        self.navigationItem.title = productManagementType?.type
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton)
        )
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(
            title: "Done",
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
        self.showAlert(title: "Really", ok: "ok", cancel: "no", action: postProduct)
    }
}
