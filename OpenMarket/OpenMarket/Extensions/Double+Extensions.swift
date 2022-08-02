//
//  Double+Extensions.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

extension Double {
    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
