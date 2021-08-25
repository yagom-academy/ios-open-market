//
//  ItemList.swift
//  OpenMarket
//
//  Created by 수박, ehd on 2021/08/10.
//

import Foundation

struct GoodsList: Decodable {
    var page: Int
    var items: [Goods]
    
    subscript(index: Int) -> Goods {
        return items[index]
    }
}
