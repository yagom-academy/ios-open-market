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
    
    struct Image: Codable {
        let id: Int?
        let url: String?
        let thumbnailUrl: String?
        let succeed: Bool?
        let issuedAt: Date?
    }
    
    struct Vendor: Codable {
        let name: String?
        let id: Int?
        let createdAt: Date?
        let issuedAt: Date?
    }
}
