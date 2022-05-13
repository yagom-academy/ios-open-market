//
//  APIable.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIable {
    var hostAPI: String { get }
    var path: String { get }
    var param: [String: String]? { get }
    var method: HTTPMethod { get }
}
