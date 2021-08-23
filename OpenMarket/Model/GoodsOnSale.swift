//
//  Item.swift
//  OpenMarket
//
//  Created by 수박, ehd on 2021/08/10.
//

import Foundation

struct GoodsOnSale: Decodable {
    
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let discountedPrice: Int?
    let currency: String
    let stock: Int
    let thumbnailURLs: [String]
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock
        case discountedPrice = "discounted_price"
        case thumbnailURLs = "thumbnails"
        case registrationDate = "registration_date"
    }
}
