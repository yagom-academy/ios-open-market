//
//  URL.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

enum HTTPMethod {
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

enum RequestType {
    case loadItemList(page: Int)
    case loadItem(id: Int)
    case uploadItem
    case editItem(id: Int)
    case deleteItem(id: Int)
    
    var path: String {
        switch self {
        case .loadItemList(let page):
            return "/items/\(page)"
        case .loadItem(let id), .editItem(let id), .deleteItem(let id):
            return "/item/\(id)"
        case .uploadItem:
            return"/item"
        }
    }
}

struct URLManager {
    private static let baseURL = "https://camp-open-market.herokuapp.com"
    
    static func makeURL(type: RequestType) -> URL? {
        guard let urlString = makeUrlString(type: type) else {
            print("url 없음")
            return nil
        }
        let url = URL(string: urlString)
        return url
    }
    
    private static func makeUrlString(type: RequestType) -> String? {
        var urlString = URLManager.baseURL
        urlString.append(type.path)
        return urlString
    }
}
