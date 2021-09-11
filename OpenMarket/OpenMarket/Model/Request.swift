//
//  Request.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/02.
//

import Foundation

enum Request {
    case getList
    case getItem
    case postItem
    case patchItem
    case deleteItem

    static let baseURL = "https://camp-open-market-2.herokuapp.com"

    var path: String {
        switch self {
        case .getList:
            return "/items"
        default:
            return "/item"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getList, .getItem :
            return .get
        case .postItem:
            return .post
        case .patchItem:
            return .patch
        case .deleteItem:
            return .delete
        }
    }

    var body: Data? {
        switch self {
        case .getList, .getItem:
            return nil
        case .postItem, .patchItem, .deleteItem:
            return Data()
        }
    }

    var contentType: String {
        switch self {
        case .getList, .getItem:
            return "application/json"
        case .postItem, .patchItem, .deleteItem:
            return "multipart/form-data"
        }
    }
}

extension Request {
    func configure(request: Request, path: Int) -> Result<URLRequest, NetworkError> {
        guard let url = URL(string: Request.baseURL + request.path + "/\(path)") else {
            return .failure(.invalidURL)
        }
        var userRequest = URLRequest(url: url)
        userRequest.httpMethod = request.method.name
        userRequest.httpBody = request.body
        userRequest.setValue(request.contentType, forHTTPHeaderField: "Content-Type")

        return .success(userRequest)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"

    var name: String {
        return self.rawValue
    }
}
