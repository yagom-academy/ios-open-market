//
//  RequestHandler.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/02/04.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum RequestType {
    case getPage(page: Int)
    case getItem(id: Int)
    case post(itme: ItemToUpdate)
    case patch(id: Int, item: ItemToUpdate)
    case delete(id: Int, item: ItemToDelete)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getPage, .getItem:
            return .get
        case .post:
            return .post
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
    
    var url: URL? {
        var url: URL?
        switch self {
        case .getPage(let page):
            url = URLManager.makeURL(type: .itemsListPage(page))
        case .getItem(let id):
            url = URLManager.makeURL(type: .itemId(id))
        case .post(_):
            url = URLManager.makeURL(type: .registItem)
        case .patch(let id, _):
            url = URLManager.makeURL(type: .itemId(id))
        case .delete(let id, _):
            url = URLManager.makeURL(type: .itemId(id))
        }
        
        return url
    }
}

