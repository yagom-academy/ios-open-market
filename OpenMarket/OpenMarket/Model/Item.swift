//
//  Item.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/02.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let discountedPrice: Int?
    let currency: String
    let stock: Int
    let thumbnailURLs: [String]
    let imageURLs: [String]?
    let registrationUnixTime: Double
    var registrationDate: Date {
        return Date(timeIntervalSince1970: registrationUnixTime)
    }

    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, discountedPrice, currency, stock
        case thumbnailURLs = "thumbnails"
        case imageURLs = "images"
        case registrationUnixTime = "registrationDate"
    }
}
