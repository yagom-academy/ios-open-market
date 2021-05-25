//
//  DELETEItem.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/24.
//

import Foundation

struct DELETEResponseItem {
    var id, price, stock: UInt
    var discountedPrice: UInt?
    var title, currency, description: String
    var thumbnails, images: [String]
    var registrationDate: Double
}

extension DELETEResponseItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, price, stock, title, currency, thumbnails, images
        case description = "descriptions"
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
