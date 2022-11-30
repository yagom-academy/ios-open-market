//  Double+.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/25.

import Foundation

extension Double {
    func formatToDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        guard let result = formatter.string(from: self as NSNumber) else {
            return "\(self)"
        }
        
        return result
    }
    
    func formatPrice(_ currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        switch currency {
        case .krw:
            formatter.maximumFractionDigits = 0
        case .usd:
            formatter.maximumFractionDigits = 2
        }

        guard let result = formatter.string(from: self as NSNumber) else {
            return "\(currency.rawValue) \(self)"
        }
        
        return "\(currency.rawValue) " + result
    }
}
