//
//  ItemRegistrationForm.swift
//  OpenMarket
//
//  Created by steven on 2021/05/11.
//

import Foundation

struct ProductForm {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
    
    var multiFormData: [String: String] {
        var datas: [String: String] = [:]
        
        if let title = title {
            datas["title"] = title
        }
        
        if let descriptions = descriptions {
            datas["descriptions"] = descriptions
        }
        
        if let price = price {
            datas["price"] = String(price)
        }
        
        if let currency = currency {
            datas["currency"] = currency
        }
        
        if let stock = stock {
            datas["stock"] = String(stock)
        }
        
        if let discountedPrice = discountedPrice {
            datas["discounted_price"] = String(discountedPrice)
        }
        
        datas["password"] = password
        
        return datas
    }
}
