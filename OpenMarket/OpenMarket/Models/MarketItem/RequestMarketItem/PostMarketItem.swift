//
//  PostMarketItem.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/16.
//

import Foundation

struct PostMarketItem: Codable {
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var images: [Data]
    var password: String
    
    init(postKey password: String, title: String, descriptions: String, price: Int, currency: String, stock: Int, discountedPrice: Int? = nil, images: [Data]) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case title, descriptions, price, currency, stock, images, password
    }
}
