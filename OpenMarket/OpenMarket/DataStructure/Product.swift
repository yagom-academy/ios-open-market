//
//  Product.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/10.
//

import Foundation

struct Product: Codable {
    let id: Int
    var title: String
    var description: String?
    var price: Int
    var currency: String
    var stock: UInt
    var discountedPrice: Int?
    let thumbnails: [String]
    var images: [String]?
    let registraionDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case thumbnails
        case images
        case registraionDate = "registration_date"
    }
}
