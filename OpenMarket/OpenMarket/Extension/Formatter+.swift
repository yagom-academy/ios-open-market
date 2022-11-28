//  Formatter+.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/25.

import Foundation

extension Formatter {
    static func format(_ number: Double, _ currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        switch currency {
        case .krw:
            formatter.maximumFractionDigits = 0
        case .usd:
            formatter.maximumFractionDigits = 2
        }

        guard let result = formatter.string(from: number as NSNumber) else {
            return "\(currency.rawValue) \(number)"
        }
        
        return "\(currency.rawValue) " + result
    }
}
