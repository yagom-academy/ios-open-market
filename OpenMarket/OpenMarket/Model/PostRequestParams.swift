//
//  PostRequestParams.swift
//  OpenMarket
//
//  Created by 서현웅 on 2022/12/01.
//

import Foundation

struct PostRequestParams: Encodable {
    let name, description, secret: String
    let price, discountedPrice, stock: Int
    let currency: Currency

    enum CodingKeys: String, CodingKey {
        case name, description, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
