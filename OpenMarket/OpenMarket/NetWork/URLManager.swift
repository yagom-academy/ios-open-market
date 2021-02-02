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
    case uploadItem(item: ItemToPost)
    case editItem(id: Int, item: ItemToPatch)
    case deleteItem(id: Int, item: ItemToDelete)
    
    var path: String {
        switch self {
        case .loadItemList(let page):
            return "/items/\(page)"
        case .loadItem(let id):
            return "/item/\(id)"
        case .editItem(let id, _):
            return "/item/\(id)"
        case .deleteItem(let id, _):
            return "/item/\(id)"
        case .uploadItem:
            return"/item"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadItem:
            return .post
        case .editItem:
            return .patch
        case .deleteItem:
            return .delete
        default:
            return .get
        }
    }
    
    var encodedData: Data? {
        switch self {
        case .deleteItem(_, let item):
            return Parser.encodeData(item)
        default:
            return nil
        }
    }
    
    func urlRequest() -> URLRequest? {
        guard let url = URLManager.makeURL(type: self) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.description
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = self.encodedData
        return urlRequest
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
