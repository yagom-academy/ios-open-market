//
//  ProductSearch.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/10.
//

import Foundation

struct ProductSearch: Codable {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var registrationDate: Double
    var descriptions: String
    var images: [String]
    
    enum CodingKeys: String, CodingKey  {
        case id, title, price, currency, stock, thumbnails, descriptions, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}

