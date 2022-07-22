//
//  APIRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    case put
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        }
    }
}

enum URLHost {
    case openMarket
    
    var url: String {
        switch self {
        case .openMarket:
            return "https://market-training.yagom-academy.kr"
        }
    }
}

enum URLAdditionalPath {
    case healthChecker
    case product
    
    var value: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .product:
            return "/api/products"
        }
    }
    
    var mockFileName: String {
        switch self {
        case .healthChecker:
            return ""
        case .product:
            return "MockData"
        }
    }
}

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: Data? { get }
    var path: URLAdditionalPath { get }
}

extension APIRequest {
    var url: URL? {
        var component = URLComponents(string: self.baseURL)
        component?.queryItems = query?.reduce([URLQueryItem]()) {
            $0 + [URLQueryItem(name: $1.key, value: $1.value)]
        }
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.name
        request.httpBody = self.body
        self.headers?.forEach { request.addValue($0, forHTTPHeaderField: $1) }
        
        return request
    }
}
