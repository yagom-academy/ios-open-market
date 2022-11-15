//
//  Item.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//
struct Item: Codable {
    let id, vendorId: Int
    let vendorName: String?
    let name, pageDescription: String
    let thumbnail: String
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String
    let images: [Image]?
    let vendors: Vendors?
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case vendorName, name
        case pageDescription = "description"
        case thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendors
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

struct Vendors: Codable {
    let id: Int
    let name: String
}
