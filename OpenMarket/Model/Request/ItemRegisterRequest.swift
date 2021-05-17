//
//  PostItemRequest.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/11.


import Foundation

struct ItemRegisterRequest: Codable, Equatable {
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var images: [String]
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
