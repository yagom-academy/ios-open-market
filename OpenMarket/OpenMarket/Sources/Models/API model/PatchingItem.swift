//
//  PatchingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PatchingItem: Encodable, FormData {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String

    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
