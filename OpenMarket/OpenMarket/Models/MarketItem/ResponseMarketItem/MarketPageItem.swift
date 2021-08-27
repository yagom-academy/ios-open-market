//
//  MarketItem.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/10.
//

import Foundation

struct MarketPageItem: Codable {
    var id: Int
    var title: String
    var price: Int
    var discountedPrice: Int?
    var currency: String
    var stock: Int
    var thumbnails: [String]
    var registrationDate: Date
    
    enum CodingKeys: String, CodingKey {
        case registrationDate = "registration_date"
        case discountedPrice = "discounted_price"
        case id, title, price, currency, stock, thumbnails
    }
}
