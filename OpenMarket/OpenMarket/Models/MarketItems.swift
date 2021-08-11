//
//  MarketItems.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/10.
//

import Foundation

struct MarketItems: Codable {
    var page: Int
    var items: [MarketPageItem]
}
