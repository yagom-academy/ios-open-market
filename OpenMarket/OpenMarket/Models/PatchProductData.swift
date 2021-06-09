//
//  PatchProductData.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/09.
//

import Foundation

struct PatchProductData: Encodable {
    
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
    
    enum Codingkeys: String, CodingKey {
        case title, descriptions, price, currency, stock, password, images
        case discountedPrice = "discounted_price"
    }
    
}
