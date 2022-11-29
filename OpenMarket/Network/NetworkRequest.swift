//
//  NetworkRequest.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

protocol NetworkRequest {
    var httpMethod: HttpMethod { get }
    var urlHost: String { get }
    var urlPath: String { get }
    var queryParameters: [String: String] { get }
    var httpHeader: [String: String]? { get }
    var httpBody: Data? { get }
}

extension NetworkRequest {
    private var url: URL? {
        if queryParameters.isEmpty {
            return URL(string: urlHost + urlPath)
        }
        var urlComponents = URLComponents(string: urlHost + urlPath)
        let queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
    
    var request: URLRequest? {
        guard let url = url else {
            print("URL is nil")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.description
        request.allHTTPHeaderFields = self.httpHeader
        request.httpBody = self.httpBody
        return request
    }
}
