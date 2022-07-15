//
//  RegistrationProduct.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

struct RegistrationProduct: Encodable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int
    let stock: Int
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
            case name
            case descriptions
            case price
            case currency
            case discountedPrice = "discounted_price"
            case stock
            case secret
        }
}
