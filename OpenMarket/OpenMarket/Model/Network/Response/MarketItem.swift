//
//  MarketItem.swift
//  OpenMarket
//
//  Created by Tak on 2021/06/01.
//

import Foundation

struct MarketItem: ProductDetail {
    let id: UInt
    let title: String
    let descriptions: String
    let price: UInt
    let currency: String
    let stock: UInt
    let discountedPrice: UInt?
    let thumbnailsURL: [String]
    let registrationDate: Double
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, images
        case thumbnailsURL = "thumbnails"
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
