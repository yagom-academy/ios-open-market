//
//  ItemRegistration.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct ItemRegistration: Decodable {
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int
    let thumbnails: [String]
    let images: [String]
    let registrationDate: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case thumbnails
        case images
        case registrationDate = "registration_date"
    }
}
