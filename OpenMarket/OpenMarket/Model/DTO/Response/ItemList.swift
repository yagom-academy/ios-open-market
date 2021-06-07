//
//  GETItemList.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/24.
//

import Foundation

struct ItemList {
    var page: UInt
    var itemList: [ListedItem]
}

extension ItemList: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case itemList = "items"
    }
}

struct ListedItem {
    var id, price, stock: UInt
    var discountedPrice: UInt?
    var title, currency: String
    var thumbnails: [String]
    var registrationDate: Double
}

extension ListedItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, price, stock, title, currency, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
