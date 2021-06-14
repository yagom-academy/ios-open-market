//
//  File.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/05/31.
//

import Foundation

struct PostProductData: Encodable {
    
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Double?
    let images: [String]
    let password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images
        case discountedPrice = "discounted_price"
    }
}
