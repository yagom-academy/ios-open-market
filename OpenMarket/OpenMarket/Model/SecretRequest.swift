//
//  SecretRequest.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/09.
//

import Foundation

struct SecretRequest: Codable {
    let productID: Int
    let vendorID: String
    let vendorPassword: String
    
    private enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case vendorID = "identifier"
        case vendorPassword = "secret"
    }
}
