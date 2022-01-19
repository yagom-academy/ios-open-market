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
            
            images.forEach { image in
                let imageView = UIImageView()
                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
                ])
                imageView.image = image
                productImageStackView.insertArrangedSubview(imageView, at: 0)
            }
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
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerScrollView.delegate = self
        imagePicker.delegate = self
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, images.count < 5 {
            self.images.append(image)
        }
        dismiss(animated: true)
    }
    
}

// MARK: - AlertController Utilities
fileprivate extension UIAlertController {
    
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    
}

extension ProductCreateViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        productNameTextField.resignFirstResponder()
        productPriceTextField.resignFirstResponder()
        discountedPriceTextField.resignFirstResponder()
        productStockTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
}
