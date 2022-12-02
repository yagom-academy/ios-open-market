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
        let krwRawNumber: Int = 0
        let usdRawNumber: Int = 1
        
        switch rawNumber {
        case krwRawNumber:
            self = .krw
        case usdRawNumber:
            self = .usd
        default:
            return nil
        }
    }
}
