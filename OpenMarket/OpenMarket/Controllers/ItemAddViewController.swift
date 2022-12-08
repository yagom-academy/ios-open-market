//
//  ItemAddViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/25.
//

import UIKit

final class ItemAddViewController: ItemViewController {
    // MARK: - Property
    private let registrationImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(presentAlbum), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
    }
}

// MARK: - View Constraint
extension ItemAddViewController {
    private func configureImage() {
        self.imageStackView.addArrangedSubview(registrationImageView)
        self.registrationImageView.addSubview(registrationButton)
        
        NSLayoutConstraint.activate([
            self.registrationImageView.widthAnchor.constraint(equalToConstant: 130),
            self.registrationImageView.heightAnchor.constraint(equalToConstant: 130),
            
            self.registrationButton.topAnchor.constraint(equalTo: self.registrationImageView.topAnchor),
            self.registrationButton.bottomAnchor.constraint(equalTo: self.registrationImageView.bottomAnchor),
            self.registrationButton.leadingAnchor.constraint(equalTo: self.registrationImageView.leadingAnchor),
            self.registrationButton.trailingAnchor.constraint(equalTo: self.registrationImageView.trailingAnchor)
        ])
    }
    
}

// MARK: - Method
extension ItemAddViewController {
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationItem.title = "상품생성"
    }
}

// MARK: - UIImagePicker
extension ItemAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func presentAlbum(){
        guard itemImages.count < 5 else {
            return showAlert(title: "경고", message: "5개 이하의 이미지만 등록할 수 있습니다.", actionTitle: "확인", dismiss: false)
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.itemImages.append(image)
            self.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
        }
        
        dismiss(animated: true)
    }
}

