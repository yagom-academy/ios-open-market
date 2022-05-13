//
//  Double+.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/14.
//

import Foundation

extension Double {
    func priceFormat(currency : String?) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let price = numberFormatter.string(from: self as NSNumber),
              let currency = currency else {
            return nil
        }
        
        return currency + " " + price
    }
}
