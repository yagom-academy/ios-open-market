//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

enum HttpMethod {
    case items
    case item
    case post
    case patch
    case delete
    
    var path: String {
        switch self {
        case .items:
            return "/items/"
        case .item, .patch, .delete:
            return "/item/"
        case .post:
            return "/item"
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
