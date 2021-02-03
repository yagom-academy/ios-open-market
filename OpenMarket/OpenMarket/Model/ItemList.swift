//
//  ItemList.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

struct ItemList: Decodable {
    let page: UInt
    let items: [Item]
}
