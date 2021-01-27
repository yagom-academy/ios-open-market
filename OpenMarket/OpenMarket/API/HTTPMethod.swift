//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by Kyungmin Lee on 2021/01/28.
//

import Foundation

enum HTTPMethod<Body> {
    case get
    case post(Body)
    case patch(Body)
    case delete(Body)
    
    var method: String {
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
