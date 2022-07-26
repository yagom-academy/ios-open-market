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
    let discountedPrice: Double
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
