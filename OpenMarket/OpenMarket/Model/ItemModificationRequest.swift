//
//  ItemModificationRequest.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/28.
//

import Foundation

struct ItemModificationRequest {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
    
    init(title: String? = nil,
         descriptions: String? = nil,
         price: Int? = nil,
         currency: String? = nil,
         stock: Int? = nil,
         discountedPrice: Int? = nil,
         images: [Data]? = nil,
         password: String) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
        self.password = password
    }
    
    var description: [String: Any] {[
        "title": title,
        "descriptions": descriptions,
        "price": price,
        "currency": currency,
        "stock": stock,
        "discountedPrice": discountedPrice,
        "images": images,
        "password": password
    ]}
}
