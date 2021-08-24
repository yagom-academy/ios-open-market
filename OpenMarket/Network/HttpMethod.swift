//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

enum HttpMethod {
    case items(pageIndex: UInt)
    case item(id: String)
    case post
    case patch(id: String)
    case delete(id: String)
    
    var type: String {
        switch self {
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        default:
            return "GET"
        }
    }
}
