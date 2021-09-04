//
//  Item.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/04.
//

import Foundation

struct Item: Codable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
    let discountedPrice: Int?
    
    enum Codingkeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case registrationDate = "registration_date"
        case discountedPrice = "discounted_price"
    }
}
