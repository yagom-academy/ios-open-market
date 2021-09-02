//
//  ParameterData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/01.
//

import Foundation

struct MultipartFormData {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    let password: String
    
    var parameter: [String: Any] {
        var param: [String: Any] = ["password": self.password]
        
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
        if let discountedPrice = self.discountedPrice {
            param["discounted_price"] = discountedPrice
        }
        return param
    }
}

struct DeleteParameterData: Encodable {
    let password: String
}
