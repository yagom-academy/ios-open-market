//
//  MarketItem.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

struct MarketItem: ProductInfo, ProductDetail {
    let id: UInt
    let title: String
    let descriptions: String
    let price: UInt
    let currency: String
    let stock: UInt
    let discountedPrice: UInt?
    let thumbnails: [String]
    let images: [String]
    let registrationData: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationData = "registration_date"
    }
}
