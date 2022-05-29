//
//  Products.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/19.
//

import Foundation

struct Products: Codable, Hashable {
    let id: Int?
    let vendorId: Int?
    let name: String?
    let thumbnail: String?
    let currency: String?
    let price: Int?
    let bargainPrice: Int?
    let discountedPrice: Int?
    let stock: Int?
    let createdAt: String?
    let issuedAt: String?
    let secret: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, stock, secret
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct ProductToEncode: Encodable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int
    let stock: Int
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}

struct PatchRequest: Encodable {
    let name: String
    let descriptions: String
    let thumbnailID: Int
    let price: Int
    let currency: Currency
    let discountedPrice: Int
    let stock: Int
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
    }
}
