//
//  CustomTextField.swift
//  OpenMarket
//
//  Created by 이차민 on 2022/01/17.
//

import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.font = .preferredFont(forTextStyle: .subheadline)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
