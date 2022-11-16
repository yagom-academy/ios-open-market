//
//  Product.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String?
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    var createdAtByFormatter: Date {
        return createdAt.stringWithFormatter() ?? Date()
    }
    var issuedAtByFormatter: Date {
        return issuedAt.stringWithFormatter() ?? Date()
    }
}
