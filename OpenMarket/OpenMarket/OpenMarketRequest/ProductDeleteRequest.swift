//
//  ProductDeleteRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

import Foundation

struct ProductDeleteRequest: APIRequest {
    var baseURL: String {
        URLHost.openMarket.url
    }
    
    var path: String? {
        URLAdditionalPath.product.value + "/\(productID)" + "/\(productSeceret)"
    }
    
    var method: HTTPMethod {
        .delete
    }
    
    var headers: [String: String]? {
        [HTTPHeaders.identifier.key: HTTPHeaders.identifier.value]
    }
    
    var query: [String: String]?
    
    var body: HTTPBody?
    
    var productID: String
    
    var productSeceret: String
}
