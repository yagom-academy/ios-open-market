//
//  ItemPage.swift
//  OpenMarket
//
//  Created by kio on 2021/05/31.
//

import Foundation

struct ItemPage: Decodable {
    let page: Int
    let items: [ItemShortInformaion]
}

struct ItemShortInformaion: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationData: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationData = "registration_date"
    }
}
