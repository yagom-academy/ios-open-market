//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/25.
//

import UIKit

final class RegisterViewController: RegisterEditBaseViewController {
    
    private let picker = UIImagePickerController()
    
    private lazy var addImageButton: UIButton = {
        let imageButton = UIButton()
        let image = UIImage(systemName: "plus")
        imageButton.setImage(image, for: .normal)
        imageButton.backgroundColor = .systemGray5
        imageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        NSLayoutConstraint.activate([
            imageButton.heightAnchor.constraint(equalTo: addImageHorizontalStackView.heightAnchor),
            imageButton.widthAnchor.constraint(equalTo: addImageButton.heightAnchor)
        ])
        return imageButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
//        addImageHorizontalStackView  [addImageButton]
    }
}

// MARK: - Method
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
