//
//  Requestable.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/02.
//

import Foundation

protocol Requestable {
    var urlRequest: URLRequest { get set }
    var baseURLWithString: String { get }
    var httpMethod: HTTPMethod { get }
    
    func makeURL(path: String) -> URL
}

extension Requestable {
    func makeURL(path: String) -> URL {
        return URL(string: baseURLWithString + path)!
    }
}

protocol GETRequestable: Requestable {
    mutating func makeURLRequest(page: Int, by description: HTTPMethod)
}

extension GETRequestable {
    mutating func makeURLRequest(page: Int, by description: HTTPMethod) {
        switch description {
        case .목록조회:
            urlRequest.url = makeURL(path: "items/\(page)")
            urlRequest.httpMethod = httpMethod.rawValue
        case .상품조회:
            urlRequest.httpMethod = httpMethod.rawValue
        default:
            return
        }
    }
}
