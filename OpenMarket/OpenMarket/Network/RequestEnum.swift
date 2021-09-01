//
//  RequestEnum.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation

enum APIMethod: CustomStringConvertible {
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

enum APIURL: CustomStringConvertible {
    case getItems
    case getItem
    case post
    case patch
    case delete
    
    private static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    
    var description: String {
        switch self {
        case .getItems:
            return Self.baseURL + "items/"
        default:
            return Self.baseURL + "item/"
        }
    }
}

enum ContentType: CustomStringConvertible {
    case json
    case multipart
    
    static let httpHeaderField = "Content-Type"
    
    var description: String {
        switch self {
        case .json:
            return "application/json"
        case .multipart:
            return "multipart/form-data; boundary="
        }
    }
}
