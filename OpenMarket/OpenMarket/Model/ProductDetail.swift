//
//  ProductDetail.swift
//  OpenMarket
//
//  Created by marisol on 2022/05/29.
//

import UIKit

struct ProductDetail: Codable {
    let id: Int?
    let vendorId: Int?
    let name: String?
    let description: String?
    let thumbnail: String?
    let currency: String?
    let price: Int?
    let bargainPrice: Int?
    let discountedPrice: Int?
    let stock: Int?
    let images: [Image]?
    let vendors: Vendor?
    let createdAt: String?
    let issuedAt: String?
    let secret: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, currency, price, stock, images, vendors, secret
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct Image: Codable {
    let id: Int?
    let url: String?
    let thumbnailUrl: String?
    let isSucceed: Bool?
    let issuedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailUrl = "thumbnail_url"
        case isSucceed = "succeed"
        case issuedAt = "issued_at"
    }
}

struct Vendor: Codable {
    let name: String?
    let id: Int?
    let createdAt: String?
    let issuedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
