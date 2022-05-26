//
//  UploadProduct.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/25.
//

struct UploadProduct: Encodable {
    let name: String?
    let discountedPrice: UInt?
    let descriptions: String?
    let price: UInt?
    let stock: Int?
    let currency: Currency?
    let secret: String?
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case name, descriptions, price, stock, currency, secret
    }
}
