//
//  UpdateProductRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct UpdateProductRequest: PATCHRequest {
    
    var body: Data
    var header: [String : String]?
    var path: String
    
    init(productID: String, header: [String: String], body: Data) {
        self.path = "/api/products/\(productID)"
        self.header = header
        self.body = body
    }
}
