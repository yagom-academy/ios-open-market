//
//  Item.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/15.
//

import UIKit

struct Item: Hashable {
    let productID: Int
    let productImage: String
    let productName: String
    let price: String
    let bargainPrice: String
    let stock: String
    
    init(product: Product) {
        self.productID = product.id
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
    let thumbnailURL: String
    
    init(detailProduct: DetailProduct) {
        self.productName = detailProduct.name
        self.price = detailProduct.currency.rawValue + " " + detailProduct.price.devidePrice()
        self.bargainPrice = detailProduct.currency.rawValue + " " + detailProduct.bargainPrice.devidePrice()
        self.stock = String(detailProduct.stock)
        if let description = detailProduct.description {
            self.description = description
        } else {
            self.description = ""
        }
        self.thumbnailURL = detailProduct.thumbnail 
    }

    init(detailItem: DetailProductItem, image: String) {
        self.productName = detailItem.productName
        self.price = detailItem.price
        self.bargainPrice = detailItem.bargainPrice
        self.stock = detailItem.stock
        self.description = detailItem.description
        self.thumbnailURL = image
    }
}

extension Double {
    fileprivate func devidePrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
}
