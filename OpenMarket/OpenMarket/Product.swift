//
//  Product.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/03.
//

import Foundation

struct Product: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    var thumbnail: String
    let currency: String
    var price: Int
    var bargainPrice: Int
    var discountedPrice: Int
    var stock: Int
    var ceratedAt: String
    var issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case ceratedAt = "created_at"
        case issuedAt = "issued_at"
    }
}
