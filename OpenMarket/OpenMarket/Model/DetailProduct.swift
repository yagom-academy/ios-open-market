//
//  DetailProduct.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/11/16.
//

import Foundation

struct DetailProduct: Codable {
    let id, vendorID: Int
    let name, welcomeDescription: String
    let thumbnail: String
    let currency: String
    let price, bargainPrice, discountedPrice, stock: Int
    let createdAt, issuedAt: String
    let images: [Image]
    let vendors: Vendors

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case welcomeDescription = "description"
        case thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images, vendors
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
