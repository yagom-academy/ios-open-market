//
//  NumberTextField.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class NumberTextField: UITextField {
    private let hasDefaultValue: Bool
    var hasEnoughText: Bool {
        return hasDefaultValue == false ? hasText : true
    }
    
    init(placeholder: String? = nil, hasDefaultValue: Bool) {
        self.hasDefaultValue = hasDefaultValue
        super.init(frame: .zero)
        self.placeholder = placeholder
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        font = .preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        keyboardType = .numberPad
        borderStyle = .roundedRect
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    func setUpStyleIfNeeded() {
        if hasDefaultValue == false, hasText == true {
            layer.borderColor = UIColor.systemBlue.cgColor
        } else if hasDefaultValue == false, hasText == false {
            layer.borderColor = UIColor.red.cgColor
        }
    }
}
