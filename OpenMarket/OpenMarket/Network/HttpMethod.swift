//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

enum HttpMethod {
    case get
    case post
    case patch
    case delete
    
    var text: String {
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
