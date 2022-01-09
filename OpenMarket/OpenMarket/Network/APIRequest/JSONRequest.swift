//
//  JSONRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/09.
//

import Foundation

protocol JSONRequest: APIRequest {
    associatedtype DataType where DataType: Encodable
    
    var body: DataType { get }
}

extension JSONRequest {
    var urlRequest: URLRequest? {
        guard let url = URL(string: finalURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        header?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard JSONSerialization.isValidJSONObject(body) else { return nil }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        return request
    }
}
