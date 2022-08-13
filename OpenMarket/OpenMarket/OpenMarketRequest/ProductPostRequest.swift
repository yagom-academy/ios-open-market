//
//  ProductPostRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

import Foundation

struct ProductPostRequest: APIRequest {
    var baseURL: String {
        URLHost.openMarket.url
    }
    
    var path: String? {
        if let unwrappedProductID = productID {
            return URLAdditionalPath.product.value + "/\(unwrappedProductID)/secret"
        } else {
            return URLAdditionalPath.product.value
        }
    }
    
    var method: HTTPMethod  {
        .post
    }
    
    var headers: [String: String]? {
        var headers = [HTTPHeaders.identifier.key: HTTPHeaders.identifier.value]
        
        additionHeaders?.forEach
        {
            headers.updateValue($0.value, forKey: $0.key)
        }
        
        return headers
    }
    
    var query: [String: String]?
    
    var body: HTTPBody?
    
    var productID: String?
 
    var additionHeaders: [String: String]?
}
