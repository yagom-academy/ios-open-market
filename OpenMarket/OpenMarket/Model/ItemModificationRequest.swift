//
//  ItemModificationRequest.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/28.
//

import Foundation

struct ItemModificationRequest {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
}
