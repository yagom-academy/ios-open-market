//
//  ItemToUpload.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

struct ItemToUpload: Encodable {
    let title: String?
    let descriptions: String?
    let price: UInt?
    let currency: String?
    let stock: UInt?
    let discountedPrice: UInt?
    let images: [Data]?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, images, stock, password
        case discountedPrice = "discounted_price"
    }
    
    var parameters: [String: Any] {
        [
            "title": title,
            "descriptions": descriptions,
            "price": price,
            "currency": currency,
            "stock": stock,
            "discounted_price": discountedPrice,
            "images": images,
            "password": password
        ]
    }
}
