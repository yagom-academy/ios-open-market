//
//  Currency.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum Currency: Int {
    case won = 0
    case dollar = 1
    
    var description: String {
        switch self {
        case .won:
            return "KRW"
        case .dollar:
            return "USD"
        }
    }
}
