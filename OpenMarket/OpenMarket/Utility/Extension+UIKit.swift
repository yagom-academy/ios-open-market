//
//  Extension+UIKit.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/19.
//

import UIKit

// MARK: - UIImageView Utilities
extension UIImageView {
    
    convenience init(with image: UIImage) {
        self.init()
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
        self.image = image
    }
    
}

// MARK: - UIAlertController Utilities
extension UIAlertController {
    
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    
}

// MARK: - UIImagePickerController Utilities
extension UIImagePickerController {
    
    convenience init(allowsEditing: Bool) {
        self.init()
        self.allowsEditing = allowsEditing
    }
    
}
