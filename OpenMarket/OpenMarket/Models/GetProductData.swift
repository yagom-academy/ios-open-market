//
//  GetProductData.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/09.
//

import Foundation

struct GetProductData: Decodable {
    let id: Int
    let title: String
    let price: Int
    let descriptions: String
    let currency: String
    let stock: Int
    let images: [String]
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Double
    
    enum CodingKeys : String, CodingKey {
        case id, title, price, currency, stock, thumbnails, descriptions, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
