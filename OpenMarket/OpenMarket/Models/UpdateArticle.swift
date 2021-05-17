//
//  UpdateArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/11.
//

import Foundation

struct UpdateArticle: Encodable {
    
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
    
    enum Codingkeys: String, CodingKey {
        case title, descriptions, price, currency, stock, password, images
        case discountedPrice = "discounted_price"
    }
    
}
