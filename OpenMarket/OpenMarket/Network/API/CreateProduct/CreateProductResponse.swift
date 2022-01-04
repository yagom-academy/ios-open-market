//
//  File.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/04.
//

import Foundation

struct CreateProductResponse: Decodable {
    let id: Int
    let venderId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Decimal
    let bargainPrice: Decimal
    let discountedPrice: Decimal
    let stock: Int
    let images: [Image]
    let vendors: Vendor
    let createdAt: Date
    let issuedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case venderId = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case images
        case vendors
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct Image: Decodable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailURL = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
