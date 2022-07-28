//
//  ProductSetupViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/28.
//

import UIKit

class ProductSetupViewController: UIViewController {
    // MARK: - Properties
    private var productSetupView: ProductSetupView?
    private var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        productSetupView = ProductSetupView(self)
        setupKeyboard()
        setupPickerViewController()
    }
    @objc func keyboardWillAppear(_ sender: Notification) {
        print("keyboard up")
    }
    @objc func keyboardWillDisappear(_ sender: Notification){
        print("keyboard down")
    }
    @objc func cancelButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func doneButtonDidTapped() {
        
    }
    private func setupKeyboard() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTapped))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    private func setupPickerViewController() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        productSetupView?.addImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
    }
    
    @objc func pickImage() {
        if productSetupView?.horizontalStackView.subviews.count == 6 {
            showAlert(title: "추가할 수 없습니다", message: "5장 이상은 추가 할 수 없습니다.")
            return
        }
        self.present(imagePicker, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let failureAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        failureAlert.addAction(UIAlertAction(title: "확인", style: .default))
        present(failureAlert, animated: true)
    }
}

extension ProductSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImge = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImge
        }
        let newImageView = PickerImageView(frame: CGRect())
        newImageView.image = newImage
        productSetupView?.horizontalStackView.addArrangedSubview(newImageView)
        picker.dismiss(animated: true)
    }
}
