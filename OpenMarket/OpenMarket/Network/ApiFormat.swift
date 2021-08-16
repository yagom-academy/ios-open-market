//
//  ApiURL.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/16.
//

import Foundation

enum ApiFormat {
    case getItems
    case getItem
    case post
    case patch
    case delete
    
    static let baseUrl = "https://camp-open-market-2.herokuapp.com/"

    var url: String {
        switch self {
        case .getItems:
            return Self.baseUrl + "items/"
        case .post, .getItem, .patch, .delete:
            return Self.baseUrl + "item/"
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
