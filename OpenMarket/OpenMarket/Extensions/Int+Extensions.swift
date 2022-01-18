//
//  Int+Extensions.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/06.
//

import Foundation

extension Int {
    var stringFormat: String {
        return String(self)
    }
    
    var decimalFormat: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
