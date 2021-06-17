//
//  Item.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnailURLs: [String]
    let registrationDate: Double

    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock
        case thumbnailURLs = "thumbnails"
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
