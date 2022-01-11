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
        var request = basicRequest
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.httpBody = try? JSONEncoder().encode(body)
        return request
    }
    
}
