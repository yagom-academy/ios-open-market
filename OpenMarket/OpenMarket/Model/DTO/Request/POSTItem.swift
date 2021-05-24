//
//  POSTDTO.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/24.
//

import Foundation

struct POSTItem {
    var title, description, currency, password: String
    var price, stock: UInt
    var discountedPrice: UInt?
    var images: [String] // File
}

extension POSTItem: Encodable {
    enum CodingKey: String, CodingKey {
        case description = "descriptions"
        case discountedPrice = "discounted_price"
    }
}
