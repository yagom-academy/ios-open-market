//
//  UpdateProductRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/06.
//

import Foundation

struct UpdateProductRequestModel: Encodable {
    
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let price: Decimal?
    let currency: Currency?
    let discountedPrice: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case thumbnailID = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case secret
    }
    
}
