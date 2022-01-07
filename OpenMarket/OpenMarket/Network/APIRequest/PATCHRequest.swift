//
//  PATCHRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol PATCHRequest: APIRequest {
    
    var body: Data { get }
    
}

extension PATCHRequest {
    
    var method: String { return "PATCH" }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        header?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
}
