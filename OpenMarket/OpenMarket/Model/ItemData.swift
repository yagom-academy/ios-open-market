//
//  ItemData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/30.
//

import Foundation

struct ItemData: Codable {
    let id: String
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registraion_date"
    }
}
