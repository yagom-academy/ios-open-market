//
//  ProductRegistration.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import Foundation

struct ProductRegistration: Codable {
    let name: String?
    let price: Int?
    let discountedPrice: Int?
    let currency: String?
    let secret: String
    let descriptions: String?
    let stock: Int?
    let images: [ImageFile]?
}

struct ImageFile: Codable {
    let fileName: String
    let type: String
    let data: Data
}
