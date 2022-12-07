//
//  UITextField.swift
//  OpenMarket
//
//  Created by baem, mini on 2022/12/07.
//

import UIKit

extension UITextField {
    convenience init(
        placeholder: String,
        keyboardType: UIKeyboardType = .default
    ) {
        self.init()
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.borderStyle = .roundedRect
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
