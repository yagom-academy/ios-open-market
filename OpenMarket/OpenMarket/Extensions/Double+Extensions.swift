//
//  Double+Extensions.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/20.
//

import Foundation

extension Double {
    var decimalFormat: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
