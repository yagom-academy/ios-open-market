//
//  ItemCollection.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/10.
//

import Foundation

struct ItemCollection: Codable {
    let page: Int
    let items: [Item]
}
