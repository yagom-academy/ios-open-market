//
//  Product.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/01.
//

import Foundation

struct Product: Codable {
    var name: String
    var price: Double
    var currency: Currency
    var discountedPrice: Double = 0
    var stock: Int = 0
    var description: String
    var secret: String = "36k448andjvwgavb"
}
