//
//  PATCHItem.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/24.
//

import Foundation

struct PATCHRequestItem {
    var title, description, currency: String?
    var password: String
    var price, stock: UInt?
    var discountedPrice: UInt?
    var images: [String]? // File
}

extension PATCHRequestItem: Encodable {
    enum CodingKeys: String, CodingKey {
        case description = "descriptions"
        case discountedPrice = "discounted_price"
    }
}
