//
//  ProductListManager.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/08/02.
//

import Foundation

class ProductListManager {
    var productList: [Product] {
        didSet {
            NotificationCenter.default.post(name: .addProductList, object: nil)
        }
    }
    
    func update(list: [Product]) {
        productList = list
    }
    
    func add(list: [Product]) {
        productList += list
    }
    
    init() {
        self.productList = []
    }
}
