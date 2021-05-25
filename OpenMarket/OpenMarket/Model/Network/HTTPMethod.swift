//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/17.
//

enum HTTPMethod {
    case get, post, put, patch, delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
