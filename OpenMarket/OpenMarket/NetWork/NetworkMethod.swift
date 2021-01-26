//
//  NetworkMethod.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

enum NetworkMethod {
    case getList
    case getItem
    case post
    case patch
    case delete
    
    var path: String {
        switch self {
        case .getList:
            return "/items"
        case .getItem:
            return "/item"
        case .post:
            return "/item"
        case .patch:
            return "/item"
        case .delete:
            return "/item"
        }
    }
}
