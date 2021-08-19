//
//  ApiURL.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/16.
//

import Foundation

enum APIMethod {
    case get
    case post
    case patch
    case delete

    var method: String {
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
