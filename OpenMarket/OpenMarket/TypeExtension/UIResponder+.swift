//
//  UIResponder+.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/05.
//

import UIKit.UIResponder

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    static var currentFirstResponder: UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}
