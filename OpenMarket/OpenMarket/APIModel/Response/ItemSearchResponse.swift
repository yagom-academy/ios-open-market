//
//  ResponseItem.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/12.
//

import Foundation

struct ItemSearchResponse: Decodable {
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]
    let registrationDate: Double
    
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
