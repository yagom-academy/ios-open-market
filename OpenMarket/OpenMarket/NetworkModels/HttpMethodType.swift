//
//  HttpMethodType.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

enum HttpMethodType {
    
    case get
    case post
    case patch
    case delete
    
    var stringMethod: String {
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
