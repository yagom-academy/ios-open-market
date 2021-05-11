//
//  Items.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/11.
//

import Foundation

struct Items: Decodable {
    let page: Int
    let items: [Item]
}


struct Item: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Date
    
    enum Codingkeys: String, CodingKey {
        case id
        case title
        case price
        case currency
        case stock
        case discountPrice = "discounted_price"
        case thumbnails
        case registrationDate = "registration_date"
    }
}
