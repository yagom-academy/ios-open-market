//
//  ItemList.swift
//  OpenMarket
//
//  Created by 수박, ehd on 2021/08/10.
//

import Foundation

struct ItemList: Decodable {
    var page: Int
    var items: [Item]
    
    subscript(index: Int) -> Item {
        return items[index]
    }
}
