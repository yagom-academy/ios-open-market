//
//  DetailArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/11.
//

import Foundation

struct DetailArticle: Codable {
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]
    let registrationDate: Int
    
    enum Codingkeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails, description, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
