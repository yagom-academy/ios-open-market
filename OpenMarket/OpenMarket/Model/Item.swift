//
//  Item.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/04.
//

import Foundation

struct Item: Codable {
    var id: Int
    var title: String
    var descriptions: String?
    var price: Int
    var currency: String
    var stock: Int
    var thumbnails: [String]
    var images: [String]?
    var registrationDate: Double?
    var discountedPrice: Int?
    
    enum Codingkeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case registrationDate = "registration_date"
        case discountedPrice = "discounted_price"
    }
}
