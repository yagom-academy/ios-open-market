//
//  MarketAPI.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

enum MarketAPIType: CustomStringConvertible {
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

enum MarketAPIPath: CustomStringConvertible {
    case items
    case registrate
    case item
    case edit
    case delete
    
    var description: String {
        switch self {
        case .items:
            return "/items/"
        case .registrate:
            return "/item"
        case .item:
            return "/item/"
        case .edit:
            return "/item/"
        case .delete:
            return "/item/"
        }
    }
}
