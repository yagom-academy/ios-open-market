//
//  UI.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/12/05.
//

import UIKit

extension ProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let transSize = CGSize(width: img.size.width / 10, height: img.size.height / 10)
                let resizeImage = img.resizeImageTo(size: transSize)
                
                let imageView = UIImageView(image: resizeImage)
                
                self.imageStackView.addArrangedSubview(imageView)
                
                if self.imageStackView.subviews.count == 5 {
                    self.addProductButton.isHidden = true
                    
                    self.imageStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 4).isActive = true
                }
                
                imageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            } else {
                print("image nil")
            }
        }
    }
}
