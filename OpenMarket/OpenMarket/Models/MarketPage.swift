//
//  MarketPage.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/26.
//

import Foundation

struct MarketPage: Decodable {
    let pageNumber: Int
    let marketItems: [MarketItem]
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case marketItems = "items"
    }
}
