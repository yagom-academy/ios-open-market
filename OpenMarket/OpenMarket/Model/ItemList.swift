//
//  ItemList.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct ItemList: Decodable {
    let page: Int
    let items: [Item]
}
