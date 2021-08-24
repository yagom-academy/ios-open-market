//
//  OpenMarketItems.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/10.
//

import Foundation

//MARK:-Type when decode the data from OpenMarket Server
struct OpenMarketItems: Codable {
    let page: Int
    let items: [Item]
    
    struct Item: Codable {
        let id: Int
        let title: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: Int?
        let thumbnails: [String]
        let registrationDate: Double
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case price
            case currency
            case stock
            case discountedPrice = "discounted_price"
            case thumbnails
            case registrationDate = "registration_date"
        }
    }
}



