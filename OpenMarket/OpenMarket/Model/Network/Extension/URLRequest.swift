//
//  URLRequest.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/17.
//

import Foundation

extension URLRequest {
    static func set(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.description
        
        return urlRequest
    }
}
