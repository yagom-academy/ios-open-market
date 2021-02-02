//
//  GoodsForm.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

struct GoodsForm {
    let password: String
    var id: UInt? = nil
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    
    init(registerPassword: String,
         title: String,
         descriptions: String,
         price: Int,
         currency: String,
         stock: Int,
         discountedPrice: Int?,
         images: [Data]) {
        self.password = registerPassword
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
    }
    
    init(editPassword: String,
         title: String?,
         descriptions: String?,
         price: Int?,
         currency: String?,
         stock: Int?,
         discountedPrice: Int?,
         images: [Data]?) {
        self.password = editPassword
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
    }
    
    init(deletePassword: String,
         id: UInt) {
        self.password = deletePassword
        self.id = id
        self.title = nil
        self.descriptions = nil
        self.price = nil
        self.currency = nil
        self.stock = nil
        self.discountedPrice = nil
        self.images = nil
    }
    
    var convertParameter: [String : Any]? {
        var parameter: [String : Any] = [:]
        parameter["password"] = password
        if let id = id {
            parameter["id"] = id
        }
        if let title = title {
            parameter["title"] = title
        }
        if let descriptions = descriptions {
            parameter["descriptions"] = descriptions
        }
        if let price = price {
            parameter["price"] = price
        }
        if let currency = currency {
            parameter["currency"] = currency
        }
        if let stock = stock {
            parameter["stock"] = stock
        }
        if let discountedPrice = discountedPrice {
            parameter["discountedPrice"] = discountedPrice
        }
        // TODO: edit multi
        if let images = images {
            parameter["images"] = images
        }
        return parameter
    }
}
