//
//  PriceTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class PriceTextField: UITextField {

    weak var textFieldDelegate: TextFieldConvertible?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPost.price.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = .numberPad
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension PriceTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.convertTextFieldToDictionary(OpenMarketItemToPost.price, textField)
    }
}

