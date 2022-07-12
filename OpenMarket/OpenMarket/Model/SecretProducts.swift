//
//  secretProduct.swift
//  OpenMarket
//
//  Created by NAMU on 2022/07/12.
//

struct SecretProducts: Encodable {
    let productId: String
    let identifier: String
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case identifier
        case secret
    }
}
