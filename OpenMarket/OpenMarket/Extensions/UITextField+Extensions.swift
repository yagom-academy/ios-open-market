//
//  UITextField+Extensions.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/24.
//

import UIKit

extension UITextField {
    var isEmpty: Bool {
        guard let text = text else {
            return false
        }
        return text.isEmpty
    }
    
    var isValidText: Bool {
        return self.text?.isEmpty == false
    }
    
    var isValidNumber: Bool {
        guard let text = self.text,
                let _ = Double(text) else {
            return false
        }
        return true
    }
    
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        let emptySpaceItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        let items = [emptySpaceItem, doneBarButtonItem]
        
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    
    @objc
    private func dismissKeyboard() {
        let nextTag = tag + 1
        
        if let nextResponder = superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else if nextTag == 2 || nextTag == 4 {
            if let nextResponder = superview?.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            }
        } else {
            resignFirstResponder()
        }
    }
}
