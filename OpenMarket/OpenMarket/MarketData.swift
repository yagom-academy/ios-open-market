//
//  MarketData.swift
//  OpenMarket
//
//  Created by Sunny, James on 2021/05/11.
//

import Foundation

struct MarketItemList: Codable {
    let page: Int
    let items: [Item]
}

struct Item: Codable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let descriptions: String?
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, descriptions, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
