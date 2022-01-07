//
//  ShowProductDetail.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct ShowProductDetailRequest: GETRequest {
    var path: String
    
    init(productID: String) {
        self.path = "/api/products/\(productID)"
    }
}

