//
//  ShowProductDetail.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct ShowProductDetailRequest: OpenMarketAPIRequest {
    var method: String
    var header: [String : String]?
    var path: String
    
    init(productID: String) {
        self.method = "GET"
        self.header = nil
        self.path = "/api/products/\(productID)"
    }
}
