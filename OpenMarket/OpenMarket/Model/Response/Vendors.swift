//
//  Vendors.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/04.
//

import Foundation

struct Vendors: Codable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
