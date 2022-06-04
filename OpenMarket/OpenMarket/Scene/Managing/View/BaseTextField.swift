//
//  BaseTextField.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/06/01.
//

import UIKit

final class BaseTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(placeholder: String, keyboardType: UIKeyboardType = .default, hasToolBar: Bool = true) {
        super.init(frame: .zero)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.font = .preferredFont(forTextStyle: .subheadline)
        self.adjustsFontForContentSizeCategory = true
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        if hasToolBar {
            self.inputAccessoryView = makeToolBar()
        }
    }
    
    private func makeToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(
            x: 0.0,
            y: 0.0,
            width: UIScreen.main.bounds.size.width,
            height: 44.0)
        )
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(didTapHideButton))
        
        toolBar.items = [flexible, barButton]
        toolBar.barTintColor = .white
        toolBar.clipsToBounds = true
        return toolBar
    }
    
    @objc func didTapHideButton() {
        self.resignFirstResponder()
    }
}
