//
//  RequestEnum.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation

enum APIHTTPMethod: CaseIterable {
    case get
    case post
    case patch
    case delete
    
    var value: String {
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

enum APIURL {
    case getItems(page: Int)
    case getItem(id: Int)
    case post
    case patch(id: Int)
    case delete(id: Int)
    
    private static let baseURL =
        "https://camp-open-market-2.herokuapp.com/"
    
    var path: String {
        switch self {
        case .getItems(let page):
            return Self.baseURL + "items/\(page)"
        case .getItem(let id), .patch(let id), .delete(let id):
            return Self.baseURL + "items/\(id)"
        case .post:
            return Self.baseURL + "item/"
        }
    }
}

enum ContentType {
    case json
    case multipart
    
    static let httpHeaderField = "Content-Type"
    
    var format: String {
        switch self {
        case .json:
            return "application/json"
        case .multipart:
            return "multipart/form-data; boundary=\(Boundary.uuid)"
        }
    }
}

enum MimeType: CustomStringConvertible {
    case jpeg
    case png
    
    var description: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "image/png"
        }
    }
}

enum Boundary {
    static let uuid = "Boundary-\(UUID().uuidString)"
}
