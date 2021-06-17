//
//  ItemForRegistering.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/17.
//

import Foundation

struct ItemForRegistering: Encodable {
    let title: String
    let description: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [String]?
    let password: String
}
