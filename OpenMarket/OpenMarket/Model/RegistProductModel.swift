//
//  RegistProductModel.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/23.
//

import Foundation

struct RegistProductModel {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case title, descriptions, price, currency, stock, password
    }
    
    func createProduct() -> [String: Any] {
        var parameters: [String: Any] = [
            "title" : self.title,
            "descriptions" : self.descriptions,
            "price" : self.price,
            "currency" : self.currency,
            "stock" : self.stock,
            "password" : self.password
        ]
        if let discountedPrice = discountedPrice {
            parameters["discountedPrice"] = discountedPrice
        }
        return parameters
    }
}

