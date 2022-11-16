//
//  OpenMarket - Page.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

struct Page: Codable {
    let id: Int
    let vendorID: Int
    let vendorName: String
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case vendorName
        case name
        case description
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
