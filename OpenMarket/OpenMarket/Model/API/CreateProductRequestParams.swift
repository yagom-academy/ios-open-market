//
//  File.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/04.
//

import Foundation

struct CreateProductRequestParams: Encodable {
    let name: String
    let descriptions: String
    let price: Decimal
    let currency: Currency
    let discountedPrice: Decimal?
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
