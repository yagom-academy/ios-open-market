//
//  Double+Extensions.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

extension Double {
    func numberFormatter() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let stringNumber = numberFormatter.string(from: NSNumber(value: self)) else {
            return nil
        }
        
        return stringNumber
    }
}
