//
//  ItemListPage.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/08/12.
//

import Foundation

class ItemBundle: Decodable, ResultArgument {
    let page: Int
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case page
        case items
    }
}
