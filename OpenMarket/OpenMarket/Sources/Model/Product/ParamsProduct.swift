//
//  OpenMarket - ParamsProduct.swift
//  Created by Zhilly, Dragon. 22/11/30
//  Copyright © yagom. All rights reserved.
//

struct ParamsProduct: Codable {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    var discountedPrice: Double? = 0
    var stock: Int? = 0
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
