//
//  Vendor.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/06.
//

import Foundation

struct Vendor: Decodable, Hashable {
    
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
}
