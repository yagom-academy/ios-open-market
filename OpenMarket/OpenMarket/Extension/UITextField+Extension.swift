//
//  UITextField+Extension.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/26.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

