//
//  Product.swift
//  OpenMarket
//
//  Created by 김태현 on 2022/05/10.
//

import Foundation

struct Product: Codable {
    let name: String
    let price: Int
    let bargainPrice: Int
    let currency: String
    let thumbnail: String
    let stock: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case bargainPrice = "bargain_price"
        case currency
        case thumbnail
        case stock
    }
}
