//
//  PATCHRequestItem.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/06/07.
//

import Foundation

struct PATCHRequestItem {
    var title, description, currency: String?
    var password: String
    var price, stock, discountedPrice: UInt?
    var images: [String]? // File
}

extension PATCHRequestItem: Encodable {
    enum CodingKeys: String, CodingKey {
        case description = "descriptions"
        case discountedPrice = "discounted_price"
    }
}
