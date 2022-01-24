//
//  Extension+Foundation.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import Foundation

extension String {
    
    func convertToDecimal() -> Decimal {
        let nsDecimal = NSDecimalNumber(string: self)
        let decimal = nsDecimal.decimalValue
        return decimal
    }
    
    func convertToInt() -> Int? {
        return Int(self)
    }
    
}
