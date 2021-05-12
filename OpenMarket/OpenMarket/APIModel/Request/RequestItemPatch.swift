//
//  RequestItemPatch.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/12.
//

import Foundation

struct RequestItemPatch {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discounted_price: Int
    let images: [String]
    let password: String
}
