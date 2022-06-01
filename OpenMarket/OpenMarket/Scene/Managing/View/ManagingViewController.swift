//
//  ManagingViewController.swift
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
        static let registerBarItemTitle = "상품등록"
        static let modifyBarItemTitle = "상품수정"
        static let maxImageSize = 307200
    }
    
    lazy var managingView = ManagingView(frame: view.frame)
    
    override func loadView() {
        super.loadView()
        view = managingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotification()
        setUpTextView()
        setUpTextField()
        setUpTapGesture()
    }
}

// MARK: SetUp Method

extension ManagingViewController {
    func setUpTextView() {
        managingView.productDescriptionTextView.delegate = self
        managingView.productDescriptionTextView.addKeyboardHideButton(target: self, selector: #selector(didTapKeyboardHideButton))
    }
    
    func setUpTextField() {
        managingView.productNameTextField.delegate = self
        managingView.productPriceTextField.delegate = self
        
        managingView.productNameTextField.becomeFirstResponder()
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: Objc Method

extension ManagingViewController {
    @objc private func didTapKeyboardHideButton() {
        managingView.productDescriptionTextView.resignFirstResponder()
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

// MARK: AlertDelegate

extension ManagingViewController: ManagingAlertDelegate {
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
            .setConfirmHandler {
                switch error {
                case .productNameIsTooShort:
                    self.managingView.productNameTextField.becomeFirstResponder()
                case .productPriceIsEmpty:
                    self.managingView.productPriceTextField.becomeFirstResponder()
                case .discountedPriceHigherThanPrice:
                    self.managingView.productDiscountedTextField.becomeFirstResponder()
                case .productImageIsEmpty:
                    return
                case .exceededNumberOfImages:
                    return
                case .descriptionIsTooLong:
                    self.managingView.productDescriptionTextView.becomeFirstResponder()
                }
            }
            .showAlert()
    }
}

// MARK: UITextViewDelegate

extension ManagingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 1000 {
            showAlertInputError(with: .descriptionIsTooLong)
            return false
        }
        
        if range.length > .zero {
            return true
        }
        
        return range.location < 1000
    }
}

// MARK: UITextFieldDelegate

extension ManagingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.isEqual(managingView.productNameTextField)) {
            managingView.productPriceTextField.becomeFirstResponder()
        }
        return true
    }
}

// MARK: UIGestureRecognizerDelegate

extension ManagingViewController: UIGestureRecognizerDelegate {
    private func setUpTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
