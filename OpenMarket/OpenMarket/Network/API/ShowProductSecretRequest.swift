//
//  ShowProductSecretRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct ShowProductSecretRequest: POSTRequest {
    var header: [String : String]
    
    var body: [String : Any]
    
    var boundary: String
    
    var path: String
    
    init(productID: String, header: [String : String], body: [String : String]) {
        self.path = "/api/products/\(productID)/secret"
        self.header = header
        self.body = body
        self.boundary = UUID().uuidString
    }
}
