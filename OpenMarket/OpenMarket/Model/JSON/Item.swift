//
//  Page.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/11.
//

import Foundation

struct Item: Codable, Hashable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case vendorId = "vendor_id"
        case name = "name"
        case thumbnail = "thumbnail"
        case currency = "currency"
        case price = "price"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock = "stock"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
