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
    let createdAt: Date
    let issuedAt: Date
    let images: [ProductImage]?
    let vendors: Venders?
    
    enum CurrencyUnit: String, Decodable {
        case KRW
        case USD
        case JPY
        case HKD
        case dollar = "$"
    }
    
    var stockDescription: String {
        if stock == Int.zero {
            return String(format: "품절")
        } else {
            if stock > 1000 {
                return String(format: "잔여수량 : %@", String(self.stock/1000))
            }
            return String(format: "잔여수량 : %@", String(self.stock))
        }
    }
    
    var currencyPrice: String {
        if price > 1000 {
            return String(format: "%@ %@K", currency.rawValue, String(self.price/1000))
        }
        return String(format: "%@ %@", currency.rawValue, String(self.price))
    }
    
    var currencyBargainPrice: String {
        if bargainPrice > 1000 {
            return String(format: "%@ %@K", currency.rawValue, String(self.bargainPrice/1000))
        }
        return String(format: "%@ %@", currency.rawValue, String(self.bargainPrice))
    }
}

struct ProductImage: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let issuedAt: Date
}

struct Venders: Decodable {
    let id: Int
    let name: String
}
