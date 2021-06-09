//
//  MarketItems.swift
//  OpenMarket
//
//  Created by Tak on 2021/06/01.
//

import Foundation

struct MarketItems: ProductList {
    let page: UInt
    let items: [Information]
    
    struct Information: ProductInfo {
        let id: UInt
        let title: String
        let price: UInt
        let currency: String
        let stock: UInt
        let discountedPrice: UInt?
        let thumbnailsURL: [String]
        let registrationDate: Double
    
        enum CodingKeys: String, CodingKey {
            case id, title, price, currency, stock
            case thumbnailsURL = "thumbnails"
            case discountedPrice = "discounted_price"
            case registrationDate = "registration_date"
        }
    }
}
