//
//  OpenMarket - CurrencyEnum.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import UIKit

enum Currency: String, Codable {
    case KRWString = "KRW"
    case USDString = "USD"
    case JPYString = "JPY"
    case HKDString = "HKD"
    
    var symbol: String {
        let locale = NSLocale(localeIdentifier: self.rawValue)
        if let symbol = locale.displayName(forKey: .currencySymbol, value: self.rawValue) {
            return symbol
        }
        
        return String()
    }
}
