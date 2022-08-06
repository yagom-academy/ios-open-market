//
//  ImageGetRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/06.
//

import Foundation

struct ImageGetRequest: APIRequest {
    var baseURL: String
    
    var path: String?
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String: String]?
    
    var query: [String: String]?
    
    var body: HTTPBody?
}
