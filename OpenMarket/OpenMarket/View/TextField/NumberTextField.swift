//
//  NumberTextField.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class NumberTextField: UITextField {
    init(placeholder: String? = nil) {
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
    }
}
