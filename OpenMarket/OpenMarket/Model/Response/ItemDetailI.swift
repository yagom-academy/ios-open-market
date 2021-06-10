//
//  ItemDetail.swift
//  OpenMarket
//
//  Created by kio on 2021/05/31.
//

import Foundation

struct ItemDetail: Decodable, Equatable {
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnailURLs: [String]
    let images: [String]
    let registrationDate: Double
    
    private enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, images
        case thumbnailURLs = "thumbnails"
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
