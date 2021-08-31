//
//  POSTItem.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

struct POSTItem {
    private let title: String
    private let descriptions: String
    private let price: Int
    private let currency: String
    private let stock: Int
    private let discounted_price: Int?
    private let password: String
    
    init(title: String, descriptions: String, price: Int, currency: String, stock: Int, discounted_price: Int?, password: String) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discounted_price = discounted_price
        self.password = password
    }
    
    func parameter() -> Parameters {
        var parameter: Parameters = ["title": self.title,
                                     "descriptions": self.descriptions,
                                     "price": self.price,
                                     "currency": self.currency,
                                     "stock": self.stock,
                                     "password": self.password]
        
        if let discounted_price = self.discounted_price {
            parameter["discounted_price"] = discounted_price
        }
        return parameter
    }
}
