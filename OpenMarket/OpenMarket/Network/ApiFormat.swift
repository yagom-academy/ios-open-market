//
//  ApiURL.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/16.
//

import Foundation

enum ApiFormat {
    case getItems(page: Int)
    case getItem(id: Int)
    case post
    case patch(id: Int)
    case delete(id: Int)
    
    

    var path: String {
        switch self {
        case .getItems(let page):
            return "items/" + String(page)
        case .post:
            return "item"
        case .getItem(let id), .patch(let id), .delete(let id):
            return "item/" + String(id)
        }
    }
    
    var method: String {
        switch self {
        case .getItems, .getItem:
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
