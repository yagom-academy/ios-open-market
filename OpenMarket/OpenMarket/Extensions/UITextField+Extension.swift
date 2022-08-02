//
//  UITextField+Extension.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/28.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func setupLayer() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
    }
}
