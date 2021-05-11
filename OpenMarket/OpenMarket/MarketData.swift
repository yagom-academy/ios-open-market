//
//  MarketData.swift
//  OpenMarket
//
//  Created by Sunny, James on 2021/05/11.
//

import Foundation

//let url = "https://camp-open-market-2.herokuapp.com/"

struct MarketItemList: Codable {
    let page: Int
    let items: [MarketItems]
}

struct MarketItems: Codable {
    let stock: Int
    let registrationDate: Double
    let currency: String
    let title: String
    let thumbnails: [String]
    let id: Int
    let discountedPrice: Int?
    let price: Int
    
    private enum CodingKeys: String, CodingKey {
        case stock
        case registrationDate = "registration_date"
        case currency
        case title
        case thumbnails
        case id
        case discountedPrice = "discounted_price"
        case price
    }
}
