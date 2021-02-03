//
//  Item.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

struct Item: Decodable {
    let id: UInt
    let title: String
    let descriptions: String?
    let price: UInt
    let currency: String
    let stock: UInt
    let discountedPrice: UInt?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
