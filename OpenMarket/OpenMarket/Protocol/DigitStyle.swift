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

extension DigitStyle {
    func apply(to text: Int?) -> String {
        guard let text = text else {
            return ""
        }
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        
        guard let convertedNumber = numberformatter.string(from: text as NSNumber) else {
            return ""
        }
        return convertedNumber
    }
}
