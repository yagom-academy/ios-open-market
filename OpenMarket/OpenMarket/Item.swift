//
//  Product.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/25.
//

import Foundation

struct Item: Codable {
    let id: Int
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var images: [String]
    var registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case thumbnails
        case images
        case registrationDate = "registration_date"
    }
}






