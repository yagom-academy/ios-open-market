//
//  RegisterProductRequest.swift
//  OpenMarket
//
//  Created by 이승재 on 2022/01/07.
//

import Foundation

struct RegisterProductRequest: Encodable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int? = 0
    let stock: Int? = 0
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
