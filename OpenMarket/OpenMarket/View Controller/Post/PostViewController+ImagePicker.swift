//
//  PostViewController+ImagePicker.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import UIKit

// MARK: Alert & Open Library or Camera
extension PostViewController {
    @objc func pickImage(_ sender: Any) {
        let alert = UIAlertController(title: "사진 불러오기", message: "아무래도 사진앨범이지?", preferredStyle: .actionSheet)
        
        let imageLibrary = UIAlertAction(title: "사진앨범", style: .default) { UIAlertAction in
            self.openImageLibrary()
        }
        
        let camera = UIAlertAction(title: "카메라", style: .default) { UIAlertAction in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(imageLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openImageLibrary() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "카메라 접근 실패", message: "해당 기기로는 접근할 수 없습니다", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: Image Picker Controller Delegation
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var convertedImage = UIImage()
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if image.size.width * image.size.height > 75000 {
                let croppedImage = image.cropAsSquare()
                convertedImage = croppedImage.compressed(to: CGSize(width: 270, height: 270))
            } else {
                convertedImage = image.cropAsSquare()
            }
        }
        
        images.insert(convertedImage, at: (images.count - 1))
        
        tryAddImageCount += 1
        
        if images.count > 5 {
            images.removeLast()
        }
        
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }

        dismiss(animated: true, completion: nil)
    }
}
