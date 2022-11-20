//  ProductList.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

struct Product: Decodable, Identifiable {
    let ID: Int
    let vendorID: Int
    let name: String
    let productDescription: String
    let thumbnailURL: String
    let currency: Currency
    let price: UInt
    let bargainPrice: UInt?
    let discountedPrice: Int?
    let stock: Int
    let createdAt: String
    let issuedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case vendorID = "vendor_id"
        case name
        case productDescription = "description"
        case thumbnailURL = "thumbnail"
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
