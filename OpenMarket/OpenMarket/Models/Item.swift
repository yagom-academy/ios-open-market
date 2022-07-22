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
        self.price = product.currency.rawValue + " " + product.price.devidePrice()
        self.bargainPrice = product.currency.rawValue + " " + product.bargainPrice.devidePrice()
        self.stock = String(product.stock)
        self.productImage = product.thumbnail
    }
}

extension Int {
    fileprivate func devidePrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
}
