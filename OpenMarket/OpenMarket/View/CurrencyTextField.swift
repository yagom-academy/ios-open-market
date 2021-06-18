//
//  CurrencyTextField.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/06/18.
//

import UIKit

class CurrencyTextField: UITextField {

    weak var textFieldDelegate: TextFieldConvertible?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPost.currency.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .title3)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension CurrencyTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.convertTextFieldToDictionary(OpenMarketItemToPost.currency, textField)
    }
}
