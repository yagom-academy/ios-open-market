//
//  Product.swift
//  OpenMarket
//
//  Created by Baemini on 2022/11/14.
//

import Foundation

struct Product: Decodable {
    let id, sellerId, price, bargainPrice, discountedPrice, stock: Int
    let name, thumbnail: String
    let description: String?
    let currency: Currency
    let createdDate: String
    let issuedDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, description, currency, price, stock
        case sellerId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdDate = "created_at"
        case issuedDate = "issued_at"
    }
}
