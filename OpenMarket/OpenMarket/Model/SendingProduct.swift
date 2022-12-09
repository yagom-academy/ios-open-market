//
//  SendingProduct.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/01.
//

import Foundation

struct SendingProduct: Encodable {
    let productID: Int?
    let name, description: String
    let stock: Int
    let thumbnailID: Int?
    let discountedPrice, price: Double
    let currency: Currency
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case stock
        case productID = "product_id"
        case name, description
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
        case price, currency, secret
    }
    
    init(productID: Int? = nil,
         name: String,
         description: String,
         thumbnailID: Int? = nil,
         price: Double,
         discountedPrice: Double,
         currency: Currency,
         stock: Int,
         secret: String
    ) {
        self.productID = productID
        self.secret = secret
        self.stock = stock
        self.name = name
        self.description = description
        self.thumbnailID = thumbnailID
        self.discountedPrice = discountedPrice
        self.price = price
        self.currency = currency
    }
}
