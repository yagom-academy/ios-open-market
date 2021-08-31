//
//  APIEnum.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

//MARK: API에 사용되는 Enum
enum APIMethod {
    case get
    case post
    case patch
    case delete
}

enum APIURL {
    case getItems(page: Int)
    case getItem(id: Int)
    case patch(id: Int)
    case delete(id: Int)
    case post
    
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
}

enum ContentType {
    case json
    case multipart
}

//MARK: Enum의 추가 구현부
extension APIMethod: CustomStringConvertible {
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

extension APIURL: CustomStringConvertible {
    var description: String {
        switch self {
        case .getItems(let page):
            return Self.baseURL + "/items/\(page)"
        case .getItem(let id):
            return Self.baseURL + "/item/\(id)"
        case .patch(let id):
            return Self.baseURL + "/item/\(id)"
        case .delete(let id):
            return Self.baseURL + "/item/\(id)"
        case .post:
            return Self.baseURL + "/item"
        default:
            return Self.baseURL + "/item"
        }
    }
}

extension ContentType: CustomStringConvertible {
    var description: String {
        switch self {
        case .json:
            return "application/json"
        case .multipart:
            return "multipart/form-data; boundary="
        }
    }
}
