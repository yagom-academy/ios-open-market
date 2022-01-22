//
//  ProductCreateViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/18.
//

import UIKit

class ProductUpdateViewController: UIViewController {
    
    private(set) var model: ProductUpdateModelManager!
    
    @IBOutlet private weak var containerScrollView: UIScrollView!
    @IBOutlet private weak var productImageStackView: UIStackView!
    @IBOutlet private weak var productNameTextField: UITextField!
    @IBOutlet private weak var productPriceTextField: UITextField!
    @IBOutlet private weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var discountedPriceTextField: UITextField!
    @IBOutlet private weak var productStockTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    private var forms: Form {
        let currencyIndex = currencySegmentedControl.selectedSegmentIndex
        return Form(
            name: productNameTextField.text,
            price: productPriceTextField.text,
            currency: currencySegmentedControl.titleForSegment(at: currencyIndex),
            discountedPrice: discountedPriceTextField.text,
            stock: productStockTextField.text,
            description: descriptionTextView.text
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelgate()
        configureNotification()
        configureTextEditors()
    }
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        if model.process(forms) {
            dismiss(animated: true)
        } else {
            let title = "필수 항목이 누락되었습니다"
            let message = "할인가격, 재고수량을 제외한 나머지 항목은 필수적으로 입력되어야합니다."
            presentAcceptAlert(with: title, description: message)
        }
    }
    
    func configure(model: ProductUpdateModelManager) {
        self.model = model
    }
    
}

// MARK: - Configure View Controller
private extension ProductUpdateViewController {
    
    func configureDelgate() {
        textEditors.forEach {
            if let view = $0 as? UITextField { view.delegate = self }
            if let view = $0 as? UITextView { view.delegate = self }
        }
        model.imagesDidChangeHandler = self.updateImageStackView
    }
    
    func configureNotification() {
        let notificationCenter = NotificationCenter.default
        [
            #selector(keyboardWasShown) : UIResponder.keyboardDidShowNotification,
            #selector(keyboardWillBeHidden) : UIResponder.keyboardWillHideNotification
        ]
        .forEach { notificationCenter.addObserver(self, selector: $0, name: $1, object: nil) }
    }
    
    func configureTextEditors() {
        textEditors.forEach { $0.addButtonToInputAccessoryView(with: "Done") }
        configurePlaceholder(to: descriptionTextView, with: "여기에 상품 상세 정보를 입력해주세요!")
    }
    
    func updateImageStackView() {
        productImageStackView.subviews.forEach { $0.removed(from: productImageStackView, whenTypeIs: UIImageView.self) }
        model.currentImages.forEach { productImageStackView.insertArrangedSubview(UIImageView(with: $0), at: 0) }
    }
    
}

// MARK: - UITextField Delegate Implements
extension ProductUpdateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.moveNextView()
        return true
    }
    
}

// MARK: - UITextField Delegate Implements
extension ProductUpdateViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = nil
            textView.accessibilityValue = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        configurePlaceholder(to: textView, with: "여기에 상품 상세 정보를 입력해주세요!")
    }
    
    private func configurePlaceholder(to textView: UITextView, with message: String) {
        if textView.text.isEmpty {
            textView.text = message
            textView.textColor = .systemGray
        }
    }
    
}

// MARK: - UIView Utilities
fileprivate extension UIView {
    
    @objc
    func moveNextView() {
        let nextTag = self.tag + 1
        
        if let nextResponder = self.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            return
        }
        
        if let nextResponder = self.superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            return
        }
        
        self.resignFirstResponder()
    }
    
    func addButtonToInputAccessoryView(with title: String) {
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
                title: title,
                style: .done,
                target: self,
                action: #selector(moveNextView)
            )
        ]
        toolbar.sizeToFit()
        
        if let view = self as? UITextView {
            view.inputAccessoryView = toolbar
        }
        
        if let view = self as? UITextField {
            view.inputAccessoryView = toolbar
        }
    }
    
    func removed<T: UIView>(from stackView: UIStackView, whenTypeIs: T.Type) {
        if let imageView = self as? T {
            stackView.removeArrangedSubview(imageView)
            imageView.removeFromSuperview()
        }
    }
    
}

// MARK: - Keyboard Control Utilities
extension ProductUpdateViewController {
    
    @objc
    private func keyboardWasShown(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let keyboardSize = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        containerScrollView.contentInset = contentInset
        containerScrollView.verticalScrollIndicatorInsets = contentInset
        
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        guard let activateField = activatedTextEditors else { return }
        containerScrollView.scrollRectToVisible(activateField.frame, animated: true)
    }
    
    @objc
    private func keyboardWillBeHidden(_ notification: Notification) {
        containerScrollView.contentInset = .zero
        containerScrollView.verticalScrollIndicatorInsets = .zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textEditors.forEach { $0.resignFirstResponder() }
    }
    
}

// MARK: - Finding TextEditors Utilities
private extension ProductUpdateViewController {
    
    var textEditors: [UIView] {
        var answer: [UIView] = []
        var queue: [UIView] = [view]
        
        while !queue.isEmpty {
            let frontView = queue.removeFirst()
            
            if frontView is UITextView || frontView is UITextField {
                answer.append(frontView)
            }
            
            frontView.subviews.forEach { queue.append($0) }
        }
        
        return answer
    }
    
    var activatedTextEditors: UIView? { textEditors.filter { $0.isFirstResponder }.first }
    
}
