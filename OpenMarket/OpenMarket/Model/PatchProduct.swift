//
//  PatchProduct.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/04.
//

import Foundation

struct PatchProduct: Encodable {
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let price: Double?
    let currency: String?
    let discountedPrice: Int?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case thumbnailID = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
