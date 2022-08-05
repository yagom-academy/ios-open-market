//
//  ProductGetRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

import Foundation

struct ProductGetRequest: APIRequest {
    var baseURL: String = URLHost.openMarket.url
    
    var path: String? = URLAdditionalPath.product.value
    
    var method: HTTPMethod = .get
 
    var headers: [String : String]?
    
    var query: [String : String]?
    
    var body: Data?
}
