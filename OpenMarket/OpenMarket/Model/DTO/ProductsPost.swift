//
//  ProductsPost.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/24.
//

import UIKit

struct ProductsPost: Encodable {
    let name: String
    let descriptions: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
    let image: [ImageInfo]
    let boundary: String = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case name, descriptions, price, currency, stock, secret
    }
}

struct ImageInfo: Encodable, Hashable {
    let fileName: String
    let data: Data
    let type: String
}
