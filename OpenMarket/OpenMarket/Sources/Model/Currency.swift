//
//  OpenMarket - Currency.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

enum Currency: Codable {
    case KRWString
    case USDString
    case JPYString
    case HKDString
    
    case KRWSymbol
    case USDSymbol
    case JPYSymbol
    case HKDSymbol
    
    var name: String {
        switch self {
        case .KRWString:
            return "KRW"
        case .USDString:
            return "USD"
        case .JPYString:
            return "JPY"
        case .HKDString:
            return "HKD"
        case .KRWSymbol:
            return "₩"
        case .USDSymbol:
            return "$"
        case .JPYSymbol:
            return "￥"
        case .HKDSymbol:
            return "HK$"
        }
    }
}
