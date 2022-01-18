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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpDescriptionText()
        setUpPlaceHolder()
    }
    
    func createRegistration() -> ProductRegistration? {
        let secret = "DV!?dhTmSZkL625N"
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let price = priceTextField.text,
              let doublePrice = Double(price),
              let segmentTitle = currency.titleForSegment(at: currency.selectedSegmentIndex),
              let currency = Currency(rawValue: segmentTitle),
              let discountedPrice = Double(discountedPriceTextField.text ?? "0"),
              let stock = Int(stockTextField.text ?? "0") else {
                  return nil
              }
        
        return ProductRegistration(
            name: name,
            descriptions: description,
            price: doublePrice,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret
        )
    }
    
    func setUpDescriptionText() {
        descriptionTextView.delegate = self
        descriptionTextView.text = Placeholder.description
        descriptionTextView.textColor = .lightGray
    }
    
    func setUpPlaceHolder() {
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
