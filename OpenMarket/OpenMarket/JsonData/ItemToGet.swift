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
    var discription: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    let thumbnails: [String]
    var images: [String]
    var registrationDate: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, discription, price, currency, stock, images, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
