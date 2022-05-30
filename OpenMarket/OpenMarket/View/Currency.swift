//
//  Currency.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum Currency: String {
    case won = "KRW"
    case dollar = "USD"
    
    var number: Int {
        switch self {
        case .won:
            return 0
        case .dollar:
            return 1
        }
    }
}
