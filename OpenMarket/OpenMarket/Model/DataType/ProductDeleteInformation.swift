//
//  ProductDeleteInformation.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

struct ProductDeleteInformation: Codable {
    let identifier: String
    let productId: Int
    let productSecret: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier
        case productId = "product_id"
        case productSecret = "product_secret"
    }
}
