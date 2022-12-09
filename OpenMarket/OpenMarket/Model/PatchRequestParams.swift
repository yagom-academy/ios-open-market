//
//  PatchRequestParams.swift
//  OpenMarket
//
//  Created by 서현웅 on 2022/12/09.
//

import Foundation

struct PatchRequestParams: Encodable {
    let name, description, secret: String
    let price, discountedPrice: Double
    let stock, thumbnailID: Int
    let currency: Currency

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnailID = "thumbnail_id"
        case price, currency
        case discountedPrice = "discounted_price"
        case stock, secret
    }
}
