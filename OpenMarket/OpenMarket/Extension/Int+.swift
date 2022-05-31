//
//  Int+.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/31.
//

import Foundation

extension Int {
    func formatNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let formattedPrice = numberFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }
        
        return formattedPrice
    }
}
