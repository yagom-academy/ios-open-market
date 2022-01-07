//
//  POSTRequest.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/07.
//

import Foundation

protocol POSTRequest: APIRequest {
    
    var body: [String: Any] { get }
    var urlRequest: URLRequest? { get }
    
}

extension POSTRequest {
    
    var method: String { return "POST" }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        header?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        guard JSONSerialization.isValidJSONObject(body) else { return nil }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        return request
    }
    
}
