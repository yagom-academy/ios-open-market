//
//  ItemPageInformation.swift
//  OpenMarket
//
//  Created by kio on 2021/05/31.
//

import Foundation

struct ItemPage {
    let page: Int
    let items: [ItemShortInformaion]
}

struct ItemShortInformaion {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationData: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
