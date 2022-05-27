//
//  CurrencyType.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/27.
//

import Foundation

enum CurrencyType: Int, CaseIterable {
    case krw = 0
    case usd = 1
    
    static var inventory: [String] {
        return Self.allCases.map { $0.description }
    }
    
    var description: String {
        switch self {
        case .krw:
            return "KRW"
        case .usd:
            return "USD"
        }
    }
}
