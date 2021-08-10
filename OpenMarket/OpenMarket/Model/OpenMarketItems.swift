//
//  OpenMarketItems.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/10.
//

import Foundation

struct OpenMarketItems {
    let page: Int
    let items: [Item]
    
    struct Item {
        let id: Int
        let title: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: String?
        let thumbnails: [String]
        let registrationDate: Double
    }
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
    }
}

