//
//  Vendor.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/09.
//

import Foundation

struct Vendor: Codable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case name, id
    }
}
