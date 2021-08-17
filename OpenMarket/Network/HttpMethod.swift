//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

enum HttpMethod: CustomStringConvertible {
    case items
    case item
    case post
    case patch
    case delete
    
    var description: String {
        switch self {
        case .items:
            return "/items/"
        case .item, .patch, .delete:
            return "/item/"
        case .post:
            return "/item"
        }
    }
}
