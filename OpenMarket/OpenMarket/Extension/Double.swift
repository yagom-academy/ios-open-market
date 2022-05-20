//
//  Double.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/20.
//

import Foundation

extension Double {
    func toDecimal() -> String {
        let numberfommater = NumberFormatter()
        numberfommater.numberStyle = .decimal
        
        guard let fomattedNumber = numberfommater.string(from: self as NSNumber) else {
            return String(self)
        }
        
        return fomattedNumber
    }
}
