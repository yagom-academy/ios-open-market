//
//  ProductParams.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/09.
//

import Foundation

struct ProductParams: Codable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int
    let stock: Int
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
