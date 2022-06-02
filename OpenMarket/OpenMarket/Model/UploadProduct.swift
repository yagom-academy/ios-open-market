//
//  UploadProduct.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/25.
//

import Foundation

struct UploadProduct: Encodable {
    let name: String?
    let discountedPrice: Double?
    let descriptions: String?
    let price: Double?
    let stock: Int?
    let currency: Currency?
    let secret: String?
    var images: [ImageInformation]?
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case name, descriptions, price, stock, currency, secret
    }
}

struct ImageInformation: Encodable {
    let fileName: String
    let data: Data
    let type: String
}
