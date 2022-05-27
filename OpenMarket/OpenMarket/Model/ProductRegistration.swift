//
//  ProductRegistration.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

struct ProductRegistration: Codable {
    let name: String
    let price: Int
    let discountedPrice: Int
    let bargainPrice: Int
    let currency: String
    let secret: String
    let descriptions: String
    let stock: Int
    let imges: [Image]
}
