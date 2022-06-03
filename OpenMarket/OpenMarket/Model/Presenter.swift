//
//  Presenter.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/21.
//

import UIKit

struct Presenter {
    var productImage: String?
    var productName: String?
    var price: String?
    var bargainPrice: String?
    var stock: String?
    var description: String?
    var discountedPrice: String?
    var currency: String?
    var images: [Image]?
    
    mutating func setData(of product: Products) -> Presenter {
        let urlString = product.thumbnail
        self.productImage = urlString
        self.productName = product.name
        
        let productStock = product.stock ?? 0
        self.stock = String(productStock)
        
        return self
    }
    
    mutating func setData(of productDetail: ProductDetail) -> Presenter {
        self.images = productDetail.images
        
        self.productName = productDetail.name
        
        let productBargainPrice = productDetail.bargainPrice ?? 0
        self.bargainPrice = String(productBargainPrice)
        
        let productPrice = productDetail.price ?? 0
        self.price = String(productPrice)
        
        let productDiscountedPrice = productDetail.discountedPrice ?? 0
        self.discountedPrice = String(productDiscountedPrice)
        
        let productStock = productDetail.stock ?? 0
        self.stock = String(productStock)
    
        self.currency = productDetail.currency
        self.description = productDetail.description
        
        return self
    }
}
