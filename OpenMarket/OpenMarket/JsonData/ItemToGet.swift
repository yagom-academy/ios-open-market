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
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnailURLs: [String]
    let images: [String]
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, images
        case thumbnailURLs = "thumbnails"
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
