//
//  ProductListSearch.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/10.
//

import Foundation

struct ProductListSearch: Codable {
    let page: Int
    let items: [Product]
}

struct Product: Codable, ProductProtocol {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: String
    var discountedPrice: Int
    var thumnails: [String]
    var registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
