//
//  ItemToLoad.swift
//  OpenMarket
//
//  Created by 이학주 on 2021/02/02.
//

import Foundation

struct itemToUpload: Codable {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [Data]?
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
