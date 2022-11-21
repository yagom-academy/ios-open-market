//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

enum HttpMethod {
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
