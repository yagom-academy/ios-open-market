//
//  ItemVO.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/12.
//

import Foundation

struct ItemVO {
    var id, price, stock, discountedPrice: UInt?
    var title, currency, description: String?
    var thumnails, images: [String]?
    var registrationDate: Double?
}

extension ItemVO: Codable {
    enum CodingKeys: String, CodingKey {
        case id, price, stock, title, currency, thumnails, images
        case description = "descriptions"
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}

struct ItemListVO {
    var page: UInt?
    var itemList: [ItemVO]? // 타입 고민
}

extension ItemListVO: Codable {
    enum CodingKeys: String, CodingKey {
        case itemList = "items"
    }
}
