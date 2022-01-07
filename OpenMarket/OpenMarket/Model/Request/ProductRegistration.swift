//
//  ProductRegistration.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import Foundation

struct ProductRegistration: Codable, MultipartFormProtocol {
    let name: String
    let description: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int?
    let stock: Int?
    let secret: String
    
    var dictionary: [String: Any?] {
        ["name": self.name,
         "description": self.description,
         "price": self.price,
         "currency": self.currency,
         "discounted_price": self.discountedPrice,
         "stock": self.stock,
         "secret": self.secret]
    }
}
