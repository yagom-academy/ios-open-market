//
//  ItemListPage.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/08/12.
//

import Foundation

class ItemListPage: Decodable {
    let page: Int
    var itemList: [Item]
    
    enum CodingKeys: String, CodingKey {
        case page
        case itemList = "items"
    }
}
