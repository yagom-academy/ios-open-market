//
//  ProductParams.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/09.
//

import Foundation

struct ProductParam: Codable {
    var name: String
    var descriptions: String
    var price: Double
    var currency: Currency
    var discountedPrice: Double?
    var stock: Int?
    var secret: String
    
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
