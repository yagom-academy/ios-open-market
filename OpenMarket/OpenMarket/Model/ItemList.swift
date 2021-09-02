//
//  ItemList.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/02.
//

import Foundation

struct ItemList: Decodable {
    let page: Int
    let items: [Item]
}
