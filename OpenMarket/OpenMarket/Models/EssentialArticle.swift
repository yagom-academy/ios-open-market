                    //
//  EssentialArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/11.
//

import Foundation

struct EssentialArticle: Decodable {
    
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Double
    
    enum CodingKeys : String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
    
}
