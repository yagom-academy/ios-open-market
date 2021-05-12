//
//  OpenMarketItem.swift
//  OpenMarket
//
//  Created by TORI on 2021/05/10.
//

import Foundation

struct ItemInfo: Codable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
//    let images: [String]
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
