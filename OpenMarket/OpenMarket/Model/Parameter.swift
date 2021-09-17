//
//  ParameterData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/01.
//

import Foundation
import UIKit

struct MultipartFormData {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var password: String?
    
    var parameter: [String: Any] {
        var param: [String: Any] = [:]
        
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
        if let password = self.password {
            param["password"] = password
        }
        return param
    }
    
    func judgeNil(essentialParameter: EssentialPublicElement, completionHandler: @escaping(Any?) -> Void) {
        var judgeArray: [Any?] = []
        if essentialParameter == .post {
            judgeArray = [self.title, self.descriptions, self.price, self.currency, self.stock, self.password]
        } else if essentialParameter == .patch {
            judgeArray = [self.password]
        }
        judgeArray.forEach { value in
            completionHandler(value)
        }
    }
}

struct DeleteParameterData: Encodable {
    let password: String
}
