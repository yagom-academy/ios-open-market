//
//  APIRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol APIRequest {
    
    var finalURL: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var urlRequest: URLRequest? { get }
    var header: [String: String]? { get }
    
}

extension APIRequest {

    var finalURL: String {
        return baseURL + path
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        header?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        return request
    }
    
}
