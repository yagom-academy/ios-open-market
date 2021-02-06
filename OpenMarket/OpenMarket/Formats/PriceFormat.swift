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
    
    static func makePriceStringWithStrike(currency: String, price: UInt) -> NSMutableAttributedString? {
        let priceString = makePriceString(currency: currency, price: price)
        
        let attributeString = NSMutableAttributedString(string: priceString)
        let range = (priceString as NSString).range(of: priceString)
        attributeString.addAttribute(.strikethroughStyle, value:1,  range: range)
        return attributeString
    }
}
