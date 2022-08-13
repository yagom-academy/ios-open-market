//
//  Vendors.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/09.
//

import Foundation

struct Vendors: Decodable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
