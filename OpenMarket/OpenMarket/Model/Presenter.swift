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
        
        let urlString = product.thumbnail.absoluteString
        presenter.productImage = urlString
        presenter.productName = product.name
        
        let formattedPrice = formatNumber(price: product.price)
        presenter.price = "\(product.currency) \(formattedPrice)"
        
        let formattedBargainPrice = formatNumber(price: product.bargainPrice)
        presenter.bargainPrice = "\(product.currency) \(formattedBargainPrice)"
        
        if product.stock == 0 {
            presenter.stock = "품절"
        } else {
            presenter.stock = "잔여수량: \(product.stock)"
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
