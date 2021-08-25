//
//  StrockLabel.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

protocol StrockText {
    func strock(text: String) -> NSMutableAttributedString
}

//MARK:- Apply Strock Line to Text
extension StrockText {
    func strock(text: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
}
