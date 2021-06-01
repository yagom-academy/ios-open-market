//
//  MarketItemEdit.swift
//  OpenMarket
//
//  Created by Tak on 2021/06/01.
//

import Foundation

struct MarketItemEdit: ProductModify {
    let title: String?
    let descriptions: String?
    let price: UInt?
    let currency: String?
    let stock: UInt?
    let discountedPrice: UInt?
    let images: [Data]?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images
        case discountedPrice = "discounted_price"
    }
}
