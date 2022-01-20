//
//  ProductCreateViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import UIKit

final class ProductCreateViewController: ProductUpdateViewController {
    
    private let imagePicker = UIImagePickerController(allowsEditing: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
    }
    
    @IBAction private func imageAddbuttonClicked(_ sender: UIButton) {
        guard model.canAddImage else {
            let title = "첨부할 수 있는 이미지가 초과되었습니다"
            let message = "새로운 이미지를 첨부하려면 기존의 이미지를 제거해주세요!"
            presentAcceptAlert(with: title, description: message)
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

// MARK: - Configure View Controller
extension ProductCreateViewController {
    
    private func configureImagePicker() {
        imagePicker.delegate = self
    }
    
}

// MARK: - UIImagePicker Delegate Implements
extension ProductCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func openCamera(_ action: UIAlertAction) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera Not Available")
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary(_ action: UIAlertAction) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("photoLibrary Not Available")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            model.append(image: image)
        }
        dismiss(animated: true)
    }
    
}
