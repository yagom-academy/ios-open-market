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

extension UIViewController {
    
    func presentAcceptAlert(with title: String, description: String) {
        let alert = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert
        )
        alert.addAction(title: "확인", style: .default)
        present(alert, animated: true)
    }
    
}

// MARK: - UISegmentedControl Utilities
extension UISegmentedControl {
    
    var currentText: String {
        let currencyIndex = self.selectedSegmentIndex
        return self.titleForSegment(at: currencyIndex) ?? ""
    }
    
}

// MARK: - UIView Utilities
extension UIView {
    
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
    
    func addButtonToInputAccessoryView(with title: String) {
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

extension UITextView {
    
    func configurePlaceholderText(with message: String) {
        if self.text.isEmpty {
            self.text = message
            self.textColor = .systemGray
        }
    }
    
    func removePlaceholderText() {
        if self.textColor == .systemGray {
            self.text = nil
            self.accessibilityValue = nil
            self.textColor = .label
        }
    }
    
}
