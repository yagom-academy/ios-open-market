//
//  ItemResponse.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct ItemResponse {
    let id: Int
    let title: String
    let descriptions: String
    let price: Double
    let currency: String
    let stock: Int
    let discountedPrice: Double?
    let thumbnails: [String]
    let images: [String]
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
