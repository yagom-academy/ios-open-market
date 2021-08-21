//
//  PatchItemData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/16.
//

import Foundation

struct PatchItemData {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discounted_price: Int?
    let password: String
    
    func parameter() -> Parameters {
        var param: Parameters = ["password": self.password]
        
        if let title = self.title {
            param["title"] = title
        }
        if let descriptions = self.descriptions {
            param["descriptions"] = descriptions
        }
        if let price = self.price {
            param["price"] = price
        }
        if let currency = self.currency {
            param["currency"] = currency
        }
        if let stock = self.stock {
            param["stock"] = stock
        }
        if let discounted_price = discounted_price {
            param["discounted_price"] = discounted_price
        }
        
        return param
    }
}
