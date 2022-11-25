//
//  Item.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import Foundation

struct Item: Codable, Hashable {
    let id, vendorId: Int
    let vendorName: String?
    let name, pageDescription, thumbnail: String
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdDate, issuedDate: String
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
        case createdDate = "created_at"
        case issuedDate = "issued_at"
        case images, vendors
    }
}

struct Image: Codable, Hashable {
    let id: Int
    let url, thumbnailURL, issuedDate: String

    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case issuedDate = "issued_at"
    }
}

struct Vendors: Codable, Hashable {
    let id: Int
    let name: String
}
