//
//  OpenMarketItem.swift
//  OpenMarket
//
//  Created by TORI on 2021/05/10.
//

import Foundation

struct OpenMarketItem: Codable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discounted_price: Int?
    let thumbnails: [String]
    let images: [String]
    let registration_date: Int
}
