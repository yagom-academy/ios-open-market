//
//  Product.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

struct Product: Codable {
    private let formatConverter: FormatConverter = .init()
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    var createdDate: Date? {
        formatConverter.date(from: createdAt)
    }
    var issuedDate: Date? {
        formatConverter.date(from: issuedAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
}
