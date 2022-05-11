//
//  ProductsDetail.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/11.
//

import Foundation

struct ProductDetail: Codable {
    let id, vendorID: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Int
    let productsDescription: String
    let bargainPrice, discountedPrice, stock: Int
    let createdAt, issuedAt: String
    let images: [ProductsImage]
    let vendor: Vendor

    private enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, thumbnail, currency, price
        case productsDescription = "description"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendor = "vendors"
    }
}

struct ProductsImage: Codable {
    let id: Int
    let url, thumbnailURL: String
    let succeed: Bool
    let issuedAt: String

    private enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}

struct Vendor: Codable {
    let name: String
    let id: Int
    let createdAt, issuedAt: String

    private enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

