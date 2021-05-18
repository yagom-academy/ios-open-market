//
//  ItemList.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct ItemList: Decodable, Equatable {
    let page: Int
    let items: [Item]
}
