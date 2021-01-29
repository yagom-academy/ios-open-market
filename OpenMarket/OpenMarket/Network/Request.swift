//
//  Request.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var bodyParams: [String : Any]? { get }
    var headers: [String : String]? { get }
}

extension Request {
    var method: HTTPMethod { return .get }
    var bodyParams: [String : Any]? { return nil }
    var headers: [String : String]? { return nil }
}
