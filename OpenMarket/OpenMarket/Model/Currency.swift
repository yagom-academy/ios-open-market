//
//  Currency.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation

enum Currency: String, Codable, CaseIterable {
    case KRW = "KRW"
    case USD = "USD"
    
    var value: Int {
        switch self {
        case .KRW:
            return 0
        case .USD:
            return 1
        }
    }
}
