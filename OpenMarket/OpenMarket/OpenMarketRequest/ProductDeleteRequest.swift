//
//  ProductDeleteRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

import Foundation

struct ProductDeleteRequest: APIRequest {
    var baseURL: String
    
    var path: String?
    
    var method: HTTPMethod
    
    var headers: [String : String]?
    
    var query: [String : String]?
    
    var body: Data?
}
