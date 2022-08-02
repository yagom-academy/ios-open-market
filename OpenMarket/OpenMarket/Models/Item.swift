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

struct DetailProductItem: Hashable {
    let productName: String
    let price: String
    let bargainPrice: String
    let stock: String
    let description: String
    let images: [String]
    
    init(detailProduct: DetailProduct) {
        self.productName = detailProduct.name
        self.price = detailProduct.currency.rawValue + " " + detailProduct.price.devidePrice()
        self.bargainPrice = detailProduct.currency.rawValue + " " + detailProduct.bargainPrice.devidePrice()
        self.stock = String(detailProduct.stock)
        self.description = detailProduct.description
        self.images = detailProduct.images.map { $0.url }
    }
}

extension Double {
    fileprivate func devidePrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
}
