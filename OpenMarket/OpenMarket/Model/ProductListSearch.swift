//
//  ProductListSearch.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/10.
//

import Foundation

struct ProductListSearch: Codable , Equatable {
    
    static func == (lhs: ProductListSearch, rhs: ProductListSearch) -> Bool {
        return true
    }
    
    let page: Int
    let items: [Product]
}

struct Product: Codable, Equatable, ProductProtocol {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
