//
//  ItemList.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/21.
//

import Foundation

// MARK:- DTO for Items(ItemList)
struct ItemList {
    var page: UInt?
    var itemList: [Item]? // 타입 고민
}

extension ItemList: Codable {
    enum CodingKeys: String, CodingKey {
        case itemList = "items"
    }
}
