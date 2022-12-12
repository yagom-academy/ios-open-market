//
//  CustomTextField.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/02.
//

import UIKit

final class CustomTextField: UITextField {
    init(placeholder: String, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        translatesAutoresizingMaskIntoConstraints = false
        clearButtonMode = .always
        layer.cornerRadius = 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray3.cgColor
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
