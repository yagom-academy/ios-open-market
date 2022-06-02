//
//  RegisterProduct.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/25.
//

import Foundation

struct ProductToRegister: Encodable {
    let name: String
    let currency: Currency
    let price: Double
    let descriptions: String
    var discountedPrice: Double?
    var stock: Int?
    let secret: String = API.secret
    private enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case secret, name, currency, price, descriptions, stock
    }
}
