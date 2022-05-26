//
//  UIViewController+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

extension UIViewController: UITextViewDelegate {
  func addNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardHeight/3
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
  
  func addGestureRecognizer() {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
