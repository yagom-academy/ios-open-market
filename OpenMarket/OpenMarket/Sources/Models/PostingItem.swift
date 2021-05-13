//
//  PostingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PostingItem: FormData {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [Data]
    let password: String

    let codingKeys: [String: String] = [
        "title": "title",
        "descriptions": "descriptions",
        "price": "price",
        "currency": "currency",
        "stock": "stock",
        "discountedPrice": "discounted_price",
        "images": "images[]",
        "password": "password"
    ]
}
