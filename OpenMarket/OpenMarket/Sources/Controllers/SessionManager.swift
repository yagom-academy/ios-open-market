//
//  SessionManager.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/13.
//

import Foundation

enum HTTPMethod {
    static let get: String = "GET"
    static let post: String = "POST"
    static let patch: String = "PATCH"
    static let delete: String = "DELETE"
}

enum BaseURL {
    static let page = "https://camp-open-market-2.herokuapp.com/items/"
    static let item = "https://camp-open-market-2.herokuapp.com/item/"
}
