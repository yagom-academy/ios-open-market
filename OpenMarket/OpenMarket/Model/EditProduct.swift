//
//  EditProduct.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/01.
//

import Foundation

struct EditProduct: Codable {
    let productID: Int
    let name, description: String?
    let stock, thumbnailID: Int?
    let discountedPrice, price: Double?
    let currency: Currency?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case stock
        case productID = "product_id"
        case name, description
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
        case price, currency, secret
    }
    
    init(productID: Int,
         secret: String,
         stock: Int? = nil,
         name: String? = nil,
         description: String? = nil,
         thumbnailID: Int? = nil,
         discountedPrice: Double? = nil,
         price: Double? = nil,
         currency: Currency? = nil
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
