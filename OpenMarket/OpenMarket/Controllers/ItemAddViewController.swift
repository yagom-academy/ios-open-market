//
//  ItemAddViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/25.
//

import UIKit

class ItemAddViewController: ItemViewController {
    // MARK: - Private property
    private lazy var registerationImageView: UIView = {
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
        self.view.backgroundColor = .systemBackground
        configureNavigation()
        configureImageScrollView()
        configureImage()
        configureTextFieldAndTextView()
    }
}

extension ItemAddViewController {
    // MARK: - View Constraint
    private func configureImage() {
        self.imageStackView.addArrangedSubview(registerationImageView)
        self.registerationImageView.addSubview(registrationButton)
        
        NSLayoutConstraint.activate([
            self.registerationImageView.widthAnchor.constraint(equalToConstant: 130),
            self.registerationImageView.heightAnchor.constraint(equalToConstant: 130),
            
            self.registrationButton.topAnchor.constraint(equalTo: self.registerationImageView.topAnchor),
            self.registrationButton.bottomAnchor.constraint(equalTo: self.registerationImageView.bottomAnchor),
            self.registrationButton.leadingAnchor.constraint(equalTo: self.registerationImageView.leadingAnchor),
            self.registrationButton.trailingAnchor.constraint(equalTo: self.registerationImageView.trailingAnchor)
        ])
    }
    
}

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
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.itemImages.append(image)
            self.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
        }
        
        dismiss(animated: true)
    }
}

