//
//  Items.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let currency: String
    let title: String
    let stock: Int
    let price: Int
    let thumbnails: [String]
    let discountedPrice: Int?
    let images: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, currency, title, stock, price, thumbnails, images
        case discountedPrice = "discounted_price"
    }
}
