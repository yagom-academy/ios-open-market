//
//  DetailProduct.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/08/02.
//

import Foundation

struct DetailProduct: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let description: String?
    let vendors: Vendor
    let images: [ProductImage]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case description
        case vendors
        case images
    }
}

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct ProductImage: Decodable {
    let id: Int
    let `url`: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case succeed
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
