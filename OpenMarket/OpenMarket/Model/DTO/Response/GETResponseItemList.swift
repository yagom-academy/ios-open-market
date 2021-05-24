//
//  GETItemList.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/24.
//

import Foundation

struct GETResponseItemList {
    var page: UInt
    var itemList: [GETResponseListedItem]
}

extension GETResponseItemList: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case itemList = "items"
    }
}

struct GETResponseListedItem {
    var id, price, stock: UInt
    var discountedPrice: UInt?
    var title, currency: String
    var thumnails: [String]
    var registrationDate: Double
}

extension GETResponseListedItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, price, stock, title, currency, thumnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
