//
//  Vendor.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/09.
//

import Foundation

struct Vendor: Codable {
    let name: String
    let number: Int
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case name
        case number
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
