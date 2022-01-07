//
//  ProductModificationRequest.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/07.
//

import Foundation

struct ProductModificationRequest: Encodable {
    let name: String? = nil
    let descriptions: String? = nil
    let thumbnailIdentification: Int? = nil
    let price: Int? = nil
    let currency: Currency? = nil
    let discountedPrice: Int = 0
    let stock: Int = 0
    let secret: String

    enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case thumbnailIdentification = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
