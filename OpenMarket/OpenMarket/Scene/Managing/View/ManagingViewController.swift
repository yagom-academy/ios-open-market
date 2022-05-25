//
//  EditViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

class ManagingViewController: UIViewController {
    enum Constants {
        static let requestErrorAlertTitle = "오류 발생"
        static let requestErrorAlertConfirmTitle = "메인화면으로 돌아가기"
        static let inputErrorAlertTitle = "등록 정보 오류"
        static let inputErrorAlertConfirmTitle = "확인"
    }
    
    lazy var managingView = ManagingView(frame: view.frame)
    
    override func loadView() {
        super.loadView()
        view.addSubview(managingView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotification()
        setUpTextView()
        setUpTextField()
    }
    
    func setUpTextView() {
        managingView.productDescriptionTextView.delegate = self
        managingView.productDescriptionTextView.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
    }
    
    func setUpTextField() {
        managingView.productNameTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
        managingView.productPriceTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
        managingView.productDiscountedTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
        managingView.productStockTextField.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func didTapKeyboardHideButton() {
        managingView.productDescriptionTextView.resignFirstResponder()
        managingView.productNameTextField.resignFirstResponder()
        managingView.productPriceTextField.resignFirstResponder()
        managingView.productDiscountedTextField.resignFirstResponder()
        managingView.productStockTextField.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        managingView.topScrollView.contentInset.bottom = keyboardFrame.size.height
        
        let firstResponder = managingView.firstResponder
        
        if let textView = firstResponder as? UITextView {
            managingView.topScrollView.scrollRectToVisible(textView.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        managingView.topScrollView.contentInset = contentInset
        managingView.topScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
}

extension ManagingViewController: EditAlertDelegate {
    func showAlertRequestError(with error: Error) {
        self.alertBuilder
            .setTitle(Constants.requestErrorAlertTitle)
            .setMessage(error.localizedDescription)
            .setConfirmTitle(Constants.requestErrorAlertConfirmTitle)
            .setConfirmHandler {
                self.dismiss(animated: true)
            }
            .showAlert()
    }
    
    func showAlertInputError(with error: InputError) {
        self.alertBuilder
            .setTitle(Constants.inputErrorAlertTitle)
            .setMessage(error.localizedDescription)
            .setConfirmTitle(Constants.inputErrorAlertConfirmTitle)
            .showAlert()
    }
}

extension ManagingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 1000 {
            showAlertInputError(with: .descriptionIsTooLong)
            return false
        }
        if range.length > 0 {
            return true
        }
        return range.location < 1000
    }
}
