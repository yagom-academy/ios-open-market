//
//  ProductDetail.swift
//  OpenMarket
//
//  Created by papri, Tiana on 26/05/2022.
//

import Foundation

struct ProductDetail: Decodable, Hashable {
    let identifier: Int
    let name: String
    let price: Int
    let bargainPrice: Int
    let currency: String
    let thumbnail: String
    let stock: Int
    let description: String
    let images: [Image]
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case price
        case bargainPrice = "bargain_price"
        case currency
        case thumbnail
        case stock
        case description
        case images
    }
}



