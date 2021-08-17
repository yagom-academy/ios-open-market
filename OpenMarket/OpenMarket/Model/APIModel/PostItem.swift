//
//  GetItem.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/13.
//

import Foundation

struct PostItem: MultiPartFormProtocol {
    
    var textField: [String: String?] {
        let text: [String: String?] =
            ["title": title,
             "descriptions": descriptions,
             "price": price.description,
             "currency": currency,
             "stock": stock.description,
             "discountedPrice": discountedPrice?.description,
             "password": password]
        return text
    }
    
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var mediaFile: [Media]?
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case descriptions
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case password
    }
}
