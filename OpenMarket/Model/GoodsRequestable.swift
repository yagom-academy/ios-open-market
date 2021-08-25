//
//  ItemRequestable.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/18.
//

import Foundation

struct GoodsRequestable: Loopable, Encodable {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let password: String
    
    init(
        title: String? = nil,
        descriptions: String? = nil,
        price: Int? = nil,
        currency: String? = nil,
        stock: Int? = nil,
        discountedPrice: Int? = nil,
        password: String
    ) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.password = password
    }
}
