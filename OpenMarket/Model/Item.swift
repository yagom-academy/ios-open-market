//
//  Item.swift
//  OpenMarket
//
//  Created by 수박, ehd on 2021/08/10.
//

import Foundation

struct Item: Decodable {
    
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let thumbnailURLs: [String]
    let imageURLs: [String]?
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock
        case thumbnailURLs = "thumbnails"
        case imageURLs = "images"
        case registrationDate = "registration_date"
    }
}

