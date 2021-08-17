//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/17.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case patch
    case delete
}

extension HttpMethod {
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
