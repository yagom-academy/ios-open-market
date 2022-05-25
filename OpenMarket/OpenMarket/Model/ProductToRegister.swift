//
//  RegisterProduct.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/25.
//

import Foundation

struct ProductToRegister: Encodable {
    let name: String
    let currency: Currency
    let price: Double
    let descriptions: String
    var discountedPrice: Double?
    var stock: Int?
    let secret: String = "password"
    private enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case secret, name, currency, price, descriptions, stock
    }
}
