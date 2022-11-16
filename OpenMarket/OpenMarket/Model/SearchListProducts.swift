//
//  SearchListProducts.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/11/16.
//

import Foundation

struct SearchListProducts: Codable {
    let pageNo, itemsPerPage, totalCount, offset: Int
    let limit, lastPage: Int
    let hasNext, hasPrev: Bool
    let pages: [SearchListPage]
}

struct SearchListPage: Codable {
    let id, vendorID: Int
    let vendorName, name, pageDescription: String
    let thumbnail: String
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case vendorName, name
        case pageDescription = "description"
        case thumbnail, currency, price
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
