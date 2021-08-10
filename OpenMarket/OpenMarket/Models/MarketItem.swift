//
//  MarketItem.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/10.
//

import Foundation

struct MarketItem: Codable {
    var id: Int
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var thumbnails: [String]
    var images: [String]
    var registrationDate: Double
    
    enum CodinKeys: String, CodingKey {
        case registrationDate = "registration_date"
    }
}
