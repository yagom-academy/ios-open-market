//
//  Currency.swift
//  OpenMarket
//
//  Created by Baemini on 2022/11/14.
//

enum Currency: String, Codable, CaseIterable {
    case KRW, USD
}

extension Currency {
    init?(rawInt: Int) {
        switch rawInt {
        case 0:
            self = .KRW
        case 1:
            self = .USD
        default:
            return nil
        }
    }
}
