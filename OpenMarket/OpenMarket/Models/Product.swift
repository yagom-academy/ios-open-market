//
//  Product.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String?
    let thumbnail: String
    let currency: CurrencyUnit
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum CurrencyUnit: String, Decodable {
        case KRW
        case USD
        case JPY
        case HKD
        case dollar = "$"
    }
    
    var createdAtByFormatter: Date {
        return createdAt.stringWithFormatter() ?? Date()
    }
    
    var issuedAtByFormatter: Date {
        return issuedAt.stringWithFormatter() ?? Date()
    }
    
    var stockDescription: String {
        if stock == Int.zero {
            return String(format: "품절")
        } else {
            return String(format: "잔여수량 : %@", String(self.stock))
        }
    }
    
    var currencyPrice: String {
        return String(format: "%@ %@", currency.rawValue, String(self.price))
    }
    
    var currencyBargainPrice: String {
        return String(format: "%@ %@", currency.rawValue, String(self.bargainPrice))
    }
}

