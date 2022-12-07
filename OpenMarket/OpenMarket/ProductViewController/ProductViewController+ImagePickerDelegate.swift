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
            self.addProductButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.addProductButton.layer.borderWidth = 0.7
            self.addProductButton.layer.cornerRadius = 4
            
            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let transSize = CGSize(width: img.size.width / 20, height: img.size.height / 20)
                var resizeImage = img.resizeImageTo(size: transSize)
                
                while resizeImage.getSizeIn(.kilobyte) > 200 {
                    resizeImage = resizeImage.resizeImageTo(size: transSize)
                }
                
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
