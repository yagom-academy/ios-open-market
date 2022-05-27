//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
    private lazy var baseView = ProductRegistrationView(frame: view.frame)
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupView()
        bind()
    }
    
    private func setupView() {
        view = baseView
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationItems() {
        self.navigationItem.title = "상품등록"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapCancelButton() {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() { }
    
    private func bind() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddImageButton))
        baseView.imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapAddImageButton() {
        self.present(self.imagePicker, animated: true)
    }
}

extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
}
