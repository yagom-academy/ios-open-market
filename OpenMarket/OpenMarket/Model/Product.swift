//  ProductList.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

struct Product: Decodable {
    let id: Int
    let vendorId: Int
//    let vendorName: String
    let name: String
//    let productDescription: String
    let thumbnailUrl: String
    let currency: Currency
    let price: UInt
    let bargainPrice: UInt
    let discountPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
//        case vendorName = "vendor_name"
        case name
//        case productDescription = "description"
        case thumbnailUrl = "thumbnail"
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
