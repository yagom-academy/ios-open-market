//
//  productRegistartionModification.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/20.
//

import UIKit

class productRegisterModification: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var fixedPriceTextField: UITextField!
  @IBOutlet weak var discountedPriceTextField: UITextField!
  @IBOutlet weak var stockTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var currencySegmentControl: UISegmentedControl!
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  func addKeyboardNotification() {
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc func endEditing(){
    view.endEditing(true)
  }
  
  @objc func keyboardWillShow(_ sender: Notification) {
    guard let userInfo = sender.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
          }
    let keyboardHeight = keyboardFrame.size.height
    let contentInset = UIEdgeInsets(
      top: 0.0,
      left: 0.0,
      bottom: keyboardHeight,
      right: 0.0
    )
    mainScrollView.contentInset = contentInset
    mainScrollView.scrollIndicatorInsets = contentInset
  }
  
  @objc func keyboardWillHide(_ sender: Notification) {
    let contentInset = UIEdgeInsets.zero
    mainScrollView.contentInset = contentInset
    mainScrollView.scrollIndicatorInsets = contentInset
  }
}
