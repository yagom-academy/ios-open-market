//
//  ItemAfterPost.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/01/26.
//

import Foundation

typealias ItemAfterPost = ItemToGet
typealias ItemAfterPatch = ItemToGet

struct ItemToGet: Decodable {
    var id: Int
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    let thumbnailURLs: [String]
    var images: [String]
    var registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, images, thumbnailURLs
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
