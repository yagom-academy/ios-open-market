//
//  RequestAPI.swift
//  OpenMarket
//
//  Created by yun on 2021/08/20.
//

import Foundation

struct RequestAPI {
    enum HTTPMethod: CustomStringConvertible {
        case get
        case post
        case patch
        case delete
        
        var description: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }
    let method: HTTPMethod
    let path: String
    let body: Data?
    
    init(method: HTTPMethod, path: String, body: Data? = nil) {
        self.method = method
        self.path = path
        self.body = body
    }
}
