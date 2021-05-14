//
//  ItemForRegistration.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct ItemForRegistration: Codable {
    let title: String
    let descriptions: String
    let currency: String
    let stock: Int
    let discountedPrice: Double?
    let images: [Data]
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
