//
//  ItemForRegistration.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/11.
//

import Foundation

struct ItemForRegistration: Codable {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [Data]
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
