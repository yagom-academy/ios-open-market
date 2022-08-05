//
//  RegistrationProduct.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

struct RegistrationProduct: Encodable {
    let name: String
    let descriptions: String
    let price: Double
    let currency: String
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
