//
//  ProductDetail.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/27.
//

import Foundation

// MARK: - ProductDetail
struct ProductDetail: Codable {
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [Image]
    let vendors: Vendors
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendors
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int
    let url, thumbnailURL: String
    let succeed: Bool
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}

// MARK: - Vendors
struct Vendors: Codable {
    let name: String
    let id: Int
    let createdAt, issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
