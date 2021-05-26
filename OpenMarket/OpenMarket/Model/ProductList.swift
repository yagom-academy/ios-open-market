//
//  OpenMarketItemsList.swift
//  OpenMarket
//
//  Created by TORI on 2021/05/10.
//

import Foundation

struct ProductList: Codable {
    let page: Int
    let items: [Product]
}
