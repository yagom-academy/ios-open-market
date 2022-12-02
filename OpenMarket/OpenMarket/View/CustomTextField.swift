//
//  CustomTextField.swift
//  OpenMarket
//
//  Created by 맹선아 on 2022/12/02.
//

import UIKit

class CustomTextField: UITextField {
    init(placeHolder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        placeholder = placeHolder
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
