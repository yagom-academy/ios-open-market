//
//  PostViewController+TextViewDelegate.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/28.
//

import UIKit

// MARK: Text View Delegate
extension PostViewController: UITextViewDelegate {
    @objc
    func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.descriptionTextView.text.isEmpty {
            descriptionTextView.text = textViewPlaceHolder
            descriptionTextView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.descriptionTextView.text == textViewPlaceHolder {
            descriptionTextView.text = nil
            descriptionTextView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 1000
    }
}
