//
//  OpenMarketItemsList.swift
//  OpenMarket
//
//  Created by TORI on 2021/05/10.
//

import Foundation

struct OpenMarketItemsList: Codable {
    let page: Int
    let items: [OpenMarketItem]
}
