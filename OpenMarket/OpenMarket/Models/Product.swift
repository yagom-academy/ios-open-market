//
// /Users/zzbae/Desktop/Yagom Career Starter Camp 6기/ios-open-market/OpenMarket/OpenMarket File.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/11.
//

import Foundation

struct Product: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
