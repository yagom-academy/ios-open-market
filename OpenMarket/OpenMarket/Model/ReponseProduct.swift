//
//  ReponseProduct.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/22.
//

import Foundation

struct ResponseProduct: Decodable {
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnailURL: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [ResponseImage]
    let vendors: [Vendor]

    enum CodingKeys: String, CodingKey {
        case id, name, currency, price, stock, images, vendors
        case vendorID = "vendor_id"
        case thumbnailURL = "thumbnail"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct ResponseImage: Decodable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, url, succeed
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
