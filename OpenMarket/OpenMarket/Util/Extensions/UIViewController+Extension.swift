//
//  UIViewController+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

extension UIViewController {
  func addGestureRecognizer() {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
