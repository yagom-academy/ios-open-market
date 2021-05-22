//
//  ItemDetailUpload.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

struct ItemDetailUpload: ProductEdit {
    let title: String?
    let descriptions: String?
    let price: UInt?
    let currency: String?
    let stock: UInt?
    let discountedPrice: UInt?
    let images: [Data]?
    let password: String
    
    enum Codingkeys: String, CodingKey {
        case discountedPrice = "discounted_price"
    }
}
