//
//  Page.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/16.
//

import Foundation

struct Page: Decodable, Hashable {
    enum Currency: String, Decodable, Hashable {
        case krw = "KRW"
        case usd = "USD"
    }

    struct Image: Decodable, Hashable {
        let id: Int
        let url: String
        let thumbnailUrl: String
        let issuedAt: Date
    }

    struct Vendors: Decodable, Hashable {
        let id: Int
        let name: String
    }

    let id: Int
    let vendorId: Int
    let name: String
    let description: String?
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    let images: [Image]?
    let vendors: Vendors?
}
