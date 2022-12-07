//
//  OpenMarket - ProductEditView.swift
//  Created by Zhilly, Dragon. 22/12/07
//  Copyright © yagom. All rights reserved.
//

final class ProductEditView: BaseProductView {
    func configure(name: String, price: Double, currency: Currency, bargainPrice: Double, stock: Int, description: String) {
        titleLabel?.text = "상품수정"
        productNameTextField?.text = name
        productPriceTextField?.text = String(price)
        productBargainTextField?.text = String(bargainPrice)
        productStockTextField?.text = String(stock)
        productsContentTextView?.text = description
        
        if currency == Currency.KRWString {
            currencySelector.selectedSegmentIndex = 0
        } else {
            currencySelector.selectedSegmentIndex = 1
        }
    }
}
