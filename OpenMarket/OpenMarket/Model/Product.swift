//
//  Product.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/10.
//

import Foundation

struct Product: Codable {
    var id: Int
    var title: String
    var descriptions: String?
    var price: Int
    var currency: String
    var discountedPrice: Int?
    var stock: Int
    var thumbnails: [String]
    var images: [String]?
    var registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptions
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case thumbnails
        case images
        case registrationDate = "registration_date"
    }
}
