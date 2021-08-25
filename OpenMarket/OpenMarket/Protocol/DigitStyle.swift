//
//  NumberFormatter.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/24.
//

import Foundation

protocol DigitStyle {
    func apply(to text: Int?) -> String
}

//MARK:- Apply Decimal to Number
extension DigitStyle {
    func apply(to text: Int?) -> String {
        let emptyString = ""
        guard let text = text else {
            return emptyString
        }
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        
        guard let convertedNumber = numberformatter.string(from: text as NSNumber) else {
            return emptyString
        }
        return convertedNumber
    }
}
