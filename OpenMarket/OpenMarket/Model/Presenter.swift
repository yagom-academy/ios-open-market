//
//  Presenter.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/21.
//

import Foundation

struct Presenter {
    var productImage: String?
    var productName: String?
    var price: String?
    var bargainPrice: String?
    var stock: String?
    
    mutating func setData(of product: Products) -> Presenter {
        var presenter = Presenter()
        
        let urlString = product.thumbnail
        presenter.productImage = urlString
        presenter.productName = product.name
        
        let productPrice = product.price ?? 0
        let productCurrency = product.currency ?? ""
        
        let formattedPrice = formatNumber(price: productPrice)
        presenter.price = "\(productCurrency) \(formattedPrice)"
        
        let productBargainPrice = product.bargainPrice ?? 0
        
        let formattedBargainPrice = formatNumber(price: productBargainPrice)
        presenter.bargainPrice = "\(productCurrency) \(formattedBargainPrice)"
        
        let productStock = product.stock ?? 0
        
        if productStock == 0 {
            presenter.stock = "품절"
        } else {
            presenter.stock = "잔여수량: \(productStock)"
        }
        
        return presenter
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
