//
//  Page.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/16.
//

import Foundation

struct Page: Decodable, Hashable {
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
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    let images: [Image]?
    let vendors: Vendors?
}
