//
//  PostItemData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/13.
//

import Foundation

struct PostItemData {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    var discounted_price: Int?
    let password: String
    
    
    func parameter() -> parameters {
        var param: parameters = ["title": self.title,
                                 "descriptions": self.descriptions,
                                 "price": self.price,
                                 "currency": self.currency,
                                 "stock": self.stock,
                                 "password": self.password]
        
        if let discounted_price = discounted_price {
            param["discounted_price"] = discounted_price
        }
        
        return param
    }
}

