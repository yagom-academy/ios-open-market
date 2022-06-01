//
//  ModifyProduct.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/26.
//

import Foundation

struct ProductToModify: Encodable {
    var name: String?
    var currency: Currency?
    var price: Double?
    var descriptions: String?
    var discountedPrice: Double?
    var stock: Int?
    var secret: String = API.secret
    private enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case secret, name, currency, price, descriptions, stock
    }
}
