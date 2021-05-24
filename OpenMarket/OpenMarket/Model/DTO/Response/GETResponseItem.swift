//
//  GETItem.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/24.
//

import Foundation

struct GETResponseItem {
    var id, price, stock: UInt
    var discountedPrice: UInt?
    var title, currency, description: String
    var thumnails, images: [String]
    var registrationDate: Double
}

extension GETResponseItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, price, stock, title, currency, thumnails, images
        case description = "descriptions"
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
