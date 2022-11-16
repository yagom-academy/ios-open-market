//
//  OpenMarket - CurrencyEnum.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

enum Currency: String, Codable {
    case KRWString = "KRW"
    case USDString = "USD"
    case JPYString = "JPY"
    case HKDString = "HKD"

    case KRWSymbol = "₩"
    case USDSymbol = "$"
    case JPYSymbol = "￥"
    case HKDSymbol = "HK$"
}
