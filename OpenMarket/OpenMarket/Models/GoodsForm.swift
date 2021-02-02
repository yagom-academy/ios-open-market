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
    
    var 
}
