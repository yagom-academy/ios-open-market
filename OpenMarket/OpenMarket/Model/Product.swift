//
//  Product.swift
//  OpenMarket
//
//  Created by papri, Tiana on 10/05/2022.
//

import Foundation

struct Product: Decodable, Hashable {
    let identifier = UUID()
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
