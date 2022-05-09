//
//  Product.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/09.
//

import Foundation

struct Product: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Double
    var description: String? = nil
    let bargainPrice: Double
    let disconuntedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    var images: [Image]? = nil
    var vendors: Vendor? = nil
    
    private enum CodingKeys: String, CodingKey {
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case disconuntedPrice = "disconunted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case id, name, thumbnail, currency, price, description, stock, images, vendors
    }
}
