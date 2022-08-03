//
//  Double+Extensions.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import Foundation

extension Double {
    func priceFormat(currency : String?) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 4
        numberFormatter.roundingMode = .up
        
        guard let price = numberFormatter.string(from: self as NSNumber),
              let currency = currency else {
                  return nil
              }
        
        return currency + " " + price
    }
}
