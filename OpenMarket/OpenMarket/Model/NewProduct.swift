//
//  NewProduct.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/29.
//

import Foundation

struct NewProduct: Encodable {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double
    let stock: Int
    let secret: String
    
    init(name: String, description: String, price: Double, currency: Currency, discountedPrice: Double = 0, stock: Int = 0, secret: String) {
        self.name = name
        self.description = description
        self.price = price
        self.currency = currency
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.secret = secret
    }
}
