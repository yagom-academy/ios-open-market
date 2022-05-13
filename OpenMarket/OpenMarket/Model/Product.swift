//
//  Product.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/09.
//

import Foundation

struct Product: Codable {
    let id: Int?
    let vendorId: Int?
    let name: String?
    let thumbnail: String?
    let currency: Currency?
    let price: Double?
    let description: String?
    let bargainPrice: Double?
    let discountedPrice: Double?
    let stock: Int?
    let createdAt: Date?
    let issuedAt: Date?
    let images: [Image]?
    let vendors: Vendor?
    
    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, description, stock
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images, vendors
    }
    
    enum Currency: String, Codable {
        case KRW = "KRW"
        case USD = "USD"
    }
    
    struct Image: Codable {
        let id: Int?
        let url: String?
        let thumbnailUrl: String?
        let succeed: Bool?
        let issuedAt: Date?
        
        enum CodingKeys: String, CodingKey {
            case id, url, succeed
            case thumbnailUrl = "thumbnail_url"
            case issuedAt = "issued_at"
        }
    }
    
    struct Vendor: Codable {
        let name: String?
        let id: Int?
        let createdAt: Date?
        let issuedAt: Date?
        
        enum CodingKeys: String, CodingKey {
            case name, id
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
    }
}
