//
//  ProductSecret.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

struct ProductSecret: Codable {
    let productId: Int
    let identifier: String
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case identifier
        case secret
    }
}
