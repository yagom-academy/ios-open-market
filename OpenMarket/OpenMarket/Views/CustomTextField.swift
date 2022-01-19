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
    
    init(placeholder: String, keyboardType: UIKeyboardType = .default, hasToolBar: Bool) {
        super.init(frame: .zero)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.font = .preferredFont(forTextStyle: .subheadline)
        self.inputAccessoryView = hasToolBar ? createToolBar() : nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        let leftSpcae = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        
        toolBar.items = [leftSpcae, doneButton]
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func didTapDoneButton() {
        self.resignFirstResponder()
    }
}
