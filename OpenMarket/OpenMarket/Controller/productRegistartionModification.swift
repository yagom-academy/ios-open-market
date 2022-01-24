//
//  productRegistartionModification.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/20.
//

import UIKit

class productRegisterModification: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var imageStackView: UIStackView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var fixedPriceTextField: UITextField!
  @IBOutlet weak var discountedPriceTextField: UITextField!
  @IBOutlet weak var stockTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var characterCountLabel: UILabel!
  @IBOutlet weak var currencySegmentControl: UISegmentedControl!
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  private let textViewPlaceHolder = "상품의 상세정보를 입력해주세요."
  
  func setDescriptionTextView() {
    descriptionTextView.layer.borderWidth = 0.1
    descriptionTextView.layer.borderColor = UIColor.black.cgColor
    descriptionTextView.layer.cornerRadius = 3
    descriptionTextView.text = textViewPlaceHolder
    descriptionTextView.textColor = .lightGray
  }
  
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
      bottom: keyboardHeight + characterCountLabel.frame.height,
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

extension productRegisterModification: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if descriptionTextView.text == textViewPlaceHolder {
      textView.text = nil
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.text = textViewPlaceHolder
      textView.textColor = .lightGray
      updateCountLabel(characterCount: 0)
    }
  }
  
  func textView(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let oldString = textView.text,
          let newRange = Range(range, in: oldString) else {
            return true
          }
    let newString = oldString
      .replacingCharacters(in: newRange, with: inputString)
      .trimmingCharacters(in: .whitespacesAndNewlines)
    
    let characterCount = newString.count
    guard characterCount <= 1000 else {
      return false
    }
    updateCountLabel(characterCount: characterCount)
    
    return true
  }
  
  private func updateCountLabel(characterCount: Int) {
    characterCountLabel.text = "\(characterCount) / 1000"
    characterCountLabel.changeColor(
      targetString: "\(characterCount)",
      color: characterCount < 800 ? .darkGray : .red
    )
  }
}

extension productRegisterModification: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard var text = textField.text else {
      return true
    }
    text = text.replacingOccurrences(of: ",", with: "")
    
    if string.isEmpty {
      if text.count > 1 {
        guard let price = Int("\(text.prefix(text.count - 1))") else {
          return true
        }
        let result = PresentStyle.formatNumber(price)
        textField.text = "\(result)"
      } else {
        textField.text = ""
      }
    } else {
      guard let price = Int("\(text)\(string)") else {
        return true
      }
      let result = PresentStyle.formatNumber(price)
      textField.text = "\(result)"
    }
    return false
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
}
