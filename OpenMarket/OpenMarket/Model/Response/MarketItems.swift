//
//  MarketItems.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

struct MarketItems: ProductList {
    let page: UInt
    let items: [Infomation]
    
    struct Infomation: ProductInfo {
        let id: UInt
        let title: String
        let price: UInt
        let currency: String
        let stock: UInt
        let discountedPrice: UInt?
        let thumbnails: [String]
        let registrationData: Double
        
        enum CodingKeys: String, CodingKey {
            case id, title, price, currency, stock, thumbnails
            case discountedPrice = "discounted_price"
            case registrationData = "registration_date"
        }
    }
}
