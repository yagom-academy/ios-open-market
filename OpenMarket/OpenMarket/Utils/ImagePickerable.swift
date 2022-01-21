//
//  ImagePickerable.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/20.
//

import UIKit

protocol ImagePickerable: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
}

extension ImagePickerable {
  func actionSheetAlertForImage(){
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] (_) in
      self?.presentCamera()
    }
    let album = UIAlertAction(title: "앨범", style: .default) { [weak self] (_) in
      self?.presentAlbum()
    }
    alertController.addAction(cancel)
    alertController.addAction(camera)
    alertController.addAction(album)
    
    present(alertController, animated: true, completion: nil)
  }
  
  func presentAlbum(){
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func presentCamera(){
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
}
