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
    var urlComponents: URL? {
        var urlComponents = URLComponents(string: urlHost + urlPath)
        let queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
    
    var requestURL: URLRequest? {
        guard let urlComponents = urlComponents else {
            print("URL is nil")
            return nil
        }
        var request = URLRequest(url: urlComponents)
        request.httpMethod = self.httpMethod.description
        return request
    }
}
