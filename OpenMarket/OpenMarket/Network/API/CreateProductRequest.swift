//
//  CreateProductRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

struct CreateProductRequest: OpenMarketMultiPartRequest {
    
    var data: [MultiPartFileType]
    var path: String
    var method: HTTPMethod
    var header: [String : String]?
    
    init(header: [String: String], params: Data, images: [Image]) {
        self.path = "/api/products"
        self.method = .POST
        self.header = header
        self.data = [
            .json(name: "params", data: params),
            .image(name: "images", images: images)
        ]
    }
    
}
