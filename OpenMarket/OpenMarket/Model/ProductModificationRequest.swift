//
//  ProductModificationRequest.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/07.
//

import Foundation

struct ProductModificationRequest: Encodable {
    var name: String?
    var descriptions: String?
    var thumbnailIdentification: Int?
    var price: Int?
    var currency: Currency?
    var discountedPrice: Int = 0
    var stock: Int = 0
    var secret: String

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
