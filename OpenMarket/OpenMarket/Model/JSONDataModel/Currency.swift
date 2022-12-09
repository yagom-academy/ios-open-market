//
//  Currency.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/14.
//

enum Currency: String, Codable, Hashable {
    case krw = "KRW"
    case usd = "USD"
    
    init?(_ rawNumber: Int) {
        let KRWRawNumber: Int = 0
        let USDRawNumber: Int = 1
        
        switch rawNumber {
        case KRWRawNumber:
            self = .krw
        case USDRawNumber:
            self = .usd
        default:
            return nil
        }
    }
}
