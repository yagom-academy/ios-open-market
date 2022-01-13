//
//  ProductRegistration.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import Foundation

struct ProductRegistration: Codable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
