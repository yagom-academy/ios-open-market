//
//  Products.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/19.
//

import Foundation

struct Products: Decodable, Hashable {
    let id: Int
    let vendorId: Int
    var name: String
    let thumbnail: URL
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, stock
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
