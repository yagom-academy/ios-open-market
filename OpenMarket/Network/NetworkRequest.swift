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
}

extension NetworkRequest {
    var url: URL? {
        if queryParameters.isEmpty {
            return URL(string: urlHost + urlPath)
        }
        var urlComponents = URLComponents(string: urlHost + urlPath)
        let queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
    
    var requestURL: URLRequest? {
        guard let url = url else {
            print("URL is nil")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.description
        return request
    }
}
