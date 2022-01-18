//
//  ProductCreateViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/18.
//

import UIKit

final class ProductCreateViewController: UIViewController {
    
    private var images: [UIImage] = []
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }

    @IBAction func imageAddbuttonClicked(_ sender: UIButton) {
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
    
}

// MARK: - AlertController Utilities
fileprivate extension UIAlertController {
    
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    
}
