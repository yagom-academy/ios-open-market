//
//  UITextField.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/25.
//

import UIKit

extension UITextField {
    func addKeyboardHideButton(target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(
            x: 0.0,
            y: 0.0,
            width: UIScreen.main.bounds.size.width,
            height: 44.0)
        )
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        toolBar.barTintColor = .white
        toolBar.clipsToBounds = true
        self.inputAccessoryView = toolBar
    }
}
