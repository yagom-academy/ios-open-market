//
//  SecretProducts.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

struct SecretProducts: Codable {
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case secret
    }
}
