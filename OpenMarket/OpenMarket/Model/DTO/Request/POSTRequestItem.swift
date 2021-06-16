//
//  POSTDTO.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/24.
//

import Foundation

struct POSTRequestItem {
    var title, description, currency, password: String
    var price, stock: UInt
    var discountedPrice: UInt?
    var images: [String] // File
}

extension POSTRequestItem: Encodable {
    enum CodingKeys: String, CodingKey {
        case description = "descriptions"
        case discountedPrice = "discounted_price"
    }
}
