//
//  Item.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/15.
//

import UIKit

struct Item: Hashable {
    let productImage: String
    let productName: String
    let price: String
    let bargainPrice: String
    let stock: String
    
    init(product: Product) {
        self.productName = product.name
        self.price = String(product.price) 
        self.bargainPrice = String(product.bargainPrice)
        self.stock = String(product.stock)
        self.productImage = product.thumbnail
    }
}
