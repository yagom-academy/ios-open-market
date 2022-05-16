//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/16.
//

enum HttpMethod {
    case get
    case post
    case delete
    case patch
    
    var string: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        }
    }
}
