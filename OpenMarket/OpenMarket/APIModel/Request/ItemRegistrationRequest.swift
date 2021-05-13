//
//  ItemRegistrationRequest.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/12.
//

import Foundation

struct ItemRegistrationRequest: Encodable {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [String]
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case images
        case password
    }
    
}
