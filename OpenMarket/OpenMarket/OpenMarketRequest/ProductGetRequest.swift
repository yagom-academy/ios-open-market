//
//  ProductGetRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

import Foundation

struct ProductGetRequest: APIRequest {
    var baseURL: String {
        URLHost.openMarket.url
    }
    
    var path: String? {
        if let unwrappedProductID = productID {
            return URLAdditionalPath.product.value + "/\(unwrappedProductID)"
        } else {
            return URLAdditionalPath.product.value
        }
    }
    
    var method: HTTPMethod {
        .get
    }
 
    var headers: [String: String]?
    
    var query: [String: String]?
    
    var body: HTTPBody?
    
    var productID: String?
}
