//
//  PostProduct.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/12/1.
//

import Foundation

struct PostProduct: Encodable {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double
    let stock: Int
    let secret: String
    
    enum Currency: String, Encodable {
        case KRW
        case USD
    }
}
