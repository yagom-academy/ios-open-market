//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

enum HttpMethod {
    case items
    case item(id: String)
    case post
    case patch(id: String)
    case delete(id: String)
    
    var path: String {
        switch self {
        case .items:
            return "items/"
        case .item(id: let id),
             .patch(id: let id),
             .delete(id: let id):
            return "item/" + id
        case .post:
            return "item"
        }
    }
    
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
