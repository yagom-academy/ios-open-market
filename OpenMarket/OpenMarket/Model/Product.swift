//
//  Product.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

struct Product: Codable, Hashable {
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
    
    let identifier: String = UUID().uuidString
    
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

enum Currency: String, Codable, CaseIterable {
    case krw = "KRW"
    case usd = "USD"
    
    var index: Int {
        switch self {
        case .krw:
            return 0
        case .usd:
            return 1
        }
    }
}

struct Image: Codable {
    let id: Int
    let url, thumbnailURL: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

struct Vendor: Codable {
    let id: Int
    let name: String
}

struct Secret: Encodable {
    let secret: String
}
