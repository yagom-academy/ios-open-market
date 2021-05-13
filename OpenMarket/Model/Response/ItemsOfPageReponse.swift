//
//  ItemPage.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/10.
//

import Foundation

struct ItemsOfPageReponse: Decodable, Equatable {
    var page: Int
    var items: [Item]
}

struct Item: Decodable, Equatable {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var registrationDate: Double
    
    private enum CodingKeys: String, CodingKey {
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

