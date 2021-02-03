//
//  StringFormats.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/03.
//

import Foundation

struct PriceFormat {
    static func makePriceString(currency: String, price: UInt) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let priceWithComma = numberFormatter.string(from: NSNumber(value: price)) else {
            return currency
        }
    
        return "\(currency) \(priceWithComma)"
    }
}
