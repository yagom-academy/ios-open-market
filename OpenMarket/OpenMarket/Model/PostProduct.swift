//
//  PostProduct.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/04.
//

import Foundation

struct PostProduct: Encodable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: String
    let discountedPrice: Int?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
