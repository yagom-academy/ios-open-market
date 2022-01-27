//
//  TextFieldsStackView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/18.
//

import UIKit

enum Placeholder {
    static let name = "상품명"
    static let price = "상품가격"
    static let discountedPrice = "할인금액"
    static let stock = "재고수량"
    static let description = "상품내용을 입력해주세요. (10글자 이상)"
}

class TextFieldsStackView: UIStackView {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currency: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var nameInvalidLabel: UILabel!
    @IBOutlet weak var priceInvalidLabel: UILabel!
    @IBOutlet weak var discountedPriceInvalidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpDescriptionText()
        setUpPlaceHolder()
        setUpKeyboard()
        setUpNotification()
        setUpInvaildLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
    func createRegistration() -> ProductRegistration? {
        let secret = "DV!?dhTmSZkL625N"
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let price = priceTextField.text,
              let doublePrice = Double(price),
              let segmentTitle = currency.titleForSegment(at: currency.selectedSegmentIndex),
              let currency = Currency(rawValue: segmentTitle),
              let discountedPrice = discountedPriceTextField.text,
              let stock = stockTextField.text else {
                  return nil
              }
        
        return ProductRegistration(
            name: name,
            descriptions: description,
            price: doublePrice,
            currency: currency,
            discountedPrice: Double(discountedPrice) ?? 0,
            stock: Int(stock) ?? 0,
            secret: secret
        )
    }
    
    func createModification(_ product: Product, secret: String) -> ProductModification? {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let price = priceTextField.text,
              let doublePrice = Double(price),
              let segmentTitle = currency.titleForSegment(at: currency.selectedSegmentIndex),
              let currency = Currency(rawValue: segmentTitle),
              let discountedPrice = discountedPriceTextField.text,
              let stock = stockTextField.text else {
                  return nil
              }
        
        return ProductModification(
            secret: secret,
            name: name,
            descriptions: description,
            thumbnailID: nil,
            price: doublePrice,
            currency: currency,
            discountedPrice: Double(discountedPrice),
            stock: Int(stock)
        )
    }
    
    func setUpInvaildLabel() {
        nameInvalidLabel.isHidden = true
        priceInvalidLabel.isHidden = true
        discountedPriceInvalidLabel.isHidden = true
        
        let customFont = UIFont.systemFont(ofSize: 10)
        nameInvalidLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
        priceInvalidLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
        discountedPriceInvalidLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
        
        nameInvalidLabel.adjustsFontForContentSizeCategory = true
        priceInvalidLabel.adjustsFontForContentSizeCategory = true
        discountedPriceInvalidLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func setUpNotification() {
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let scrollView = self.superview?.superview as? UIScrollView,
              let view = self.superview?.superview?.superview else {
                  return
              }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let scrollView = self.superview?.superview as? UIScrollView else {
            return
        }
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    private func setUpKeyboard() {
        priceTextField.keyboardType = .decimalPad
        discountedPriceTextField.keyboardType = .decimalPad
        stockTextField.keyboardType = .numberPad
        descriptionTextView.isScrollEnabled = false
    }
    
    private func setUpDescriptionText() {
        descriptionTextView.delegate = self
        descriptionTextView.text = Placeholder.description
        descriptionTextView.textColor = .lightGray
    }
    
    private func setUpPlaceHolder() {
        nameTextField.placeholder = Placeholder.name
        priceTextField.placeholder = Placeholder.price
        discountedPriceTextField.placeholder = Placeholder.discountedPrice
        stockTextField.placeholder = Placeholder.stock
    }
}

extension TextFieldsStackView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Placeholder.description {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Placeholder.description
            textView.textColor = .lightGray
        }
    }
}
