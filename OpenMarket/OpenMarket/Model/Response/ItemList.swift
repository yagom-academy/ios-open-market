//
//  ItemList.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/11.
//

struct ItemList: Decodable, Equatable {
    let page: Int
    let items: [Item]
}
