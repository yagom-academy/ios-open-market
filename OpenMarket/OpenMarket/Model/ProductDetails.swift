//
//  ProductDetails.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/27.
//

import Foundation

struct ProductDetails: Decodable {
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnailURL: String
    let currency: String
    let price: Double
    let description: String
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [ImageData]
    let vendors: VendorData

    enum CodingKeys: String, CodingKey {
        case id, name, description, currency, price, stock, images, vendors
        case vendorID = "vendor_id"
        case thumbnailURL = "thumbnail"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
    struct VendorData: Decodable {
        let name: String
        let id: Int
        let createdAt: String
        let issuedAt: String
        
        enum CodingKeys: String, CodingKey {
            case name, id
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
    }
}
