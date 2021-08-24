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
    
    var path: String {
        switch self {
        case .items(let pageIndex):
            return "items/\(pageIndex.description)"
        case .item(let id),
             .patch(let id),
             .delete(let id):
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
