//
//  DeleteProductRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

struct DeleteProductRequest: APIRequest {
    var method: String
    var header: [String : String]?
    var path: String
    
    init(productID: String, productSecret: String, header: [String: String]) {
        self.method = "DELETE"
        self.path = "/api/products/\(productID)/\(productSecret)"
        self.header = header
    }
}
