//
//  ProductUpdateTextFieldDelegate.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/22.
//

import UIKit

class ProductUpdateTextFieldDelegate: NSObject {
    
}

extension ProductUpdateTextFieldDelegate: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.moveNextView()
        return true
    }
    
}
