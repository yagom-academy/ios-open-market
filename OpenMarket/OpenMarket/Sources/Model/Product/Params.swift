//
//  OpenMarket - Params.swift
//  Created by Zhilly, Dragon. 22/11/30
//  Copyright © yagom. All rights reserved.
//

struct Params: Encodable {
    let name: String
    let description: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int? = 0
    let stock: Int? = 0
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
