//
//  UITextField+Extensions.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/24.
//

import UIKit

extension UITextField {
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
        resignFirstResponder()
    }
}
