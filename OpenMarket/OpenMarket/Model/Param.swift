//
//  Param.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/05.
//

import Foundation

struct Param: Codable {
    let name, welcomeDescription: String
    let price: Int
    let currency: String
    let discountedPrice, stock: Int
    let secret: String

    enum CodingKeys: String, CodingKey {
        case name
        case welcomeDescription = "description"
        case price, currency
        case discountedPrice = "discounted_price"
        case stock, secret
    }
}
