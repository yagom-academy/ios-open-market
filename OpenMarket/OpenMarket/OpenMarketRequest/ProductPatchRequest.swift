//
//  ProductPatchRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

import Foundation

struct ProductPatchRequest: APIRequest {
    var baseURL: String = URLHost.openMarket.url
    
    var path: String? {
        URLAdditionalPath.product.value + "/\(productID)"
    }
    
    var method: HTTPMethod = .patch
    
    var headers: [String: String]? {
        [
            HTTPHeaders.identifier.key: HTTPHeaders.identifier.value,
            HTTPHeaders.json.key: HTTPHeaders.json.value
        ]
    }
    
    var query: [String: String]?
    
    var body: HTTPBody?
    
    var productID: String
}
