//
//  TextFieldEditable.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

protocol TextFieldConvertible: AnyObject {
    func convertTextFieldToDictionary(_ itemToPost: OpenMarketItemToPost, _ textField: UITextField)
}
