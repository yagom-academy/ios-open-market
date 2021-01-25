//
//  ItemToGet.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

struct ItemToGet: Decodable {
    let items: [Item]
    let page: Int
}
