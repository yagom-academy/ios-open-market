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
    var images: [String]?
    
    mutating func setData(of product: Products) -> Presenter {
        let urlString = product.thumbnail
        self.productImage = urlString
        self.productName = product.name
        
        let productPrice = product.price ?? 0
        let productCurrency = product.currency ?? ""
        
        let formattedPrice = formatNumber(price: productPrice)
        self.price = "\(productCurrency) \(formattedPrice)"
        
        let productBargainPrice = product.bargainPrice ?? 0
        
        let formattedBargainPrice = formatNumber(price: productBargainPrice)
        self.bargainPrice = "\(productCurrency) \(formattedBargainPrice)"
        
        let productStock = product.stock ?? 0
        
        if productStock == 0 {
            self.stock = "품절"
        } else {
            self.stock = "잔여수량: \(productStock)"
        }
        
        return self
    }
    
    mutating func setData(of productDetail: ProductDetail) -> Presenter {
        self.images = productDetail.images?.compactMap { image in
            image.url
        }
        
        self.productName = productDetail.name
        
        let productPrice = productDetail.price ?? 0
        
        let formattedPrice = formatNumber(price: productPrice)
        self.price = "\(formattedPrice)"
        
        let productDiscountedPrice = productDetail.discountedPrice ?? 0
        
        let formattedDiscountedPrice = formatNumber(price: productDiscountedPrice)
        self.discountedPrice = "\(formattedDiscountedPrice)"
        
        let productStock = productDetail.stock ?? 0
        
        if productStock == 0 {
            self.stock = "0"
        } else {
            self.stock = "\(productStock)"
        }
    
        self.currency = productDetail.currency
        self.description = productDetail.description
        
        return self
    }
    
    private func formatNumber(price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else {
            return ""
        }
        
        return formattedPrice
    }
}
