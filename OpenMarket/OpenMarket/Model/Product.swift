//
//  Item.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/12.
//

import Foundation

struct Product: Codable {
    var id: Int?
    var title: String
    var descriptions: String?
    var price: Int
    var currency: String
    var stock: Int
    var thumbnails: [String]?
    var productImages: [String]?
    var registrationTime: Double?
    var discountedPrice: Int?
    var password: String?
    
    enum Codingkeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, password
        case productImages = "images"
        case registrationTime = "registration_date"
        case discountedPrice = "discounted_price"
    }
    
    func createRegistProduct() -> [String: Any] {
        var parameters: [String: Any] = [
            "title": self.title,
            "descriptions": self.descriptions as Any,
            "price": self.price,
            "currency": self.currency,
            "stock": self.stock,
            "password": self.password as Any
        ]
        if let discountedPrice = discountedPrice {
            parameters["discountedPrice"] = discountedPrice
        }
        return parameters
    }
}
