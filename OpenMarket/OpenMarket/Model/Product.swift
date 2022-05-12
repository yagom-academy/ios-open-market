//
//  Products.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/10.
//
import Foundation

struct Product: Codable {
    let id: Int?
    let vendorId: Int?
    let name: String?
    let thumbnail: String?
    let currency: String?
    let price: Int?
    let bargainPrice: Int?
    let discountedPrice: Int?
    let stock: Int?
    let createdAt: String?
    let issuedAt: String?
    
    enum CodingKeys: String, CodingKey {
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
