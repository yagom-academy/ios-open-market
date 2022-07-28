//
//  Currency.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
    
    var value: String {
        switch self {
        case .krw:
            return "0"
        case .usd:
            return "1"
        }
    }
}
