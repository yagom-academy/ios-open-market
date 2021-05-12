//
//  RequestItemList.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/12.
//

import Foundation

struct ItemList: Decodable {
    let page: Int
    let items: [Item]
}

struct Item: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let thumbnails: [String]
    let registerationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case currency
        case stock
        case thumbnails
        case registerationDate = "registration_date"
    }
    
}
