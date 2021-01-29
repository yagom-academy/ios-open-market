//
//  Items.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/27.
//

import Foundation

struct Items: Codable {
    let page: Int
    var items: [LoadedItem]
    
    struct LoadedItem: Codable {
        let id: Int
        var title: String
        var price: Int
        var currency: String
        var stock: Int
        var discountedPrice: Int?
        var thumbnails: [String]
        var registrationDate: Double
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case price
            case currency
            case stock
            case discountedPrice = "discounted_price"
            case thumbnails
            case registrationDate = "registration_date"
        }
    }
}
