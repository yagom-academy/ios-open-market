//
//  Product.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//
import Foundation

struct Product: Codable {
    let id: Int
    let vendorId: Int
    let name: String
//    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    
    enum Currency: String, Codable {
        case krw = "KRW"
        case usd = "USD"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case name
//        case description
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
