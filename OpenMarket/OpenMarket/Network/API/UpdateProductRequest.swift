//
//  UpdateProductRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct UpdateProductRequest: OpenMarketJSONRequest {
    var method: String
    var body: UpdateProductRequestModel
    var header: [String : String]?
    var path: String
    
    init(productID: String, header: [String: String], body: UpdateProductRequestModel) {
        self.method = "PATCH"
        self.path = "/api/products/\(productID)"
        self.header = header
        self.body = body
    }
}
