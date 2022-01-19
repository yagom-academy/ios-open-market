//
//  ProductCreateViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/18.
//

import UIKit

final class ProductCreateViewController: UIViewController {
    
    private var images: [UIImage] = [] {
        didSet {
            productImageStackView.subviews.forEach { view in
                if let view = view as? UIImageView {
                    productImageStackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }
            }
            
            images.forEach { productImageStackView.insertArrangedSubview(UIImageView(with: $0), at: 0) }
        }
    }
    
    @IBOutlet private weak var containerScrollView: UIScrollView!
    @IBOutlet private weak var productImageStackView: UIStackView!
    @IBOutlet private weak var productNameTextField: UITextField!
    @IBOutlet private weak var productPriceTextField: UITextField!
    @IBOutlet private weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var discountedPriceTextField: UITextField!
    @IBOutlet private weak var productStockTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    private let imagePicker = UIImagePickerController(allowsEditing: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelgate()
        configureNotification()
        configureTextField()
    }
    
    private func configureDelgate() {
        imagePicker.delegate = self
        productNameTextField.delegate = self
        productPriceTextField.delegate = self
        discountedPriceTextField.delegate = self
        productStockTextField.delegate = self
    }
    
    private func configureNotification() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWasShown),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func configureTextField() {
        let nextString = "Next"
        let doneString = "Done"
        productPriceTextField.addButtonToInputAccessoryView(title: nextString)
        discountedPriceTextField.addButtonToInputAccessoryView(title: nextString)
        productStockTextField.addButtonToInputAccessoryView(title: nextString)
        descriptionTextView.addButtonToInputAccessoryView(title: doneString)
    }
    
    @IBAction private func imageAddbuttonClicked(_ sender: UIButton) {
        if images.count >= 5 {
            let alert = UIAlertController(
                title: "첨부할 수 있는 이미지가 초과되었습니다",
                message: "새로운 이미지를 첨부하려면 기존의 이미지를 제거해주세요!",
                preferredStyle: .alert
            )
            alert.addAction(title: "확인", style: .default)
            present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(
            title: "사진을 불러옵니다",
            message: "어디서 불러올까요?",
            preferredStyle: .actionSheet
        )
        alert.addAction(title: "카메라", style: .default, handler: openCamera)
        alert.addAction(title: "앨범", style: .default, handler: openPhotoLibrary)
        alert.addAction(title: "취소", style: .cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIImagePicker Delegate Implements
extension ProductCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera(_ action: UIAlertAction) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera Not Available")
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    func openPhotoLibrary(_ action: UIAlertAction) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("photoLibrary Not Available")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage, images.count < 5 {
            self.images.append(image)
        }
        dismiss(animated: true)
    }
    
}

// MARK: - UITextField Delegate Implements
extension ProductCreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.moveNextView()
        return true
    }
    
}

// MARK: - UIView Utilities
fileprivate extension UIView {
    
    @objc
    func moveNextView() {
        let nextTag = self.tag + 1
        
        if let nextResponder = self.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            return
        }
        
        if let nextResponder = self.superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            return
        }
        
        self.resignFirstResponder()
    }
    
    func addButtonToInputAccessoryView(title: String) {
        let toolbar = UIToolbar()
        
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
                title: title,
                style: .done,
                target: self,
                action: #selector(moveNextView)
            )
        ]
        
        toolbar.sizeToFit()
        
        if let view = self as? UITextView {
            view.inputAccessoryView = toolbar
        }
        
        if let view = self as? UITextField {
            view.inputAccessoryView = toolbar
        }
    }
    
}

// MARK: - Keyboard Control Utilities
extension ProductCreateViewController {
    
    @objc
    private func keyboardWasShown(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let keyboardSize = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        containerScrollView.contentInset = contentInset
        containerScrollView.verticalScrollIndicatorInsets = contentInset
        
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        guard let activateField = activatedTextEditors else { return }
        containerScrollView.scrollRectToVisible(activateField.frame, animated: true)
    }
    
    @objc
    private func keyboardWillBeHidden(_ notification: Notification) {
        containerScrollView.contentInset = .zero
        containerScrollView.verticalScrollIndicatorInsets = .zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textEditors.forEach { $0.resignFirstResponder() }
    }
    
}

// MARK: - Finding TextEditors Utilities
private extension ProductCreateViewController {
    
    var textEditors: [UIView] {
        var answer: [UIView] = []
        var queue: [UIView] = [view]
        
        while !queue.isEmpty {
            let frontView = queue.removeFirst()
            
            if frontView is UITextView || frontView is UITextField {
                answer.append(frontView)
            }
            
            frontView.subviews.forEach { queue.append($0) }
        }
        
        return answer
    }
    
    var activatedTextEditors: UIView? { textEditors.filter { $0.isFirstResponder }.first }
    
}
