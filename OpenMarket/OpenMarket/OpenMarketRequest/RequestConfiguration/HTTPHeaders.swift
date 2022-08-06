//
//  HTTPHeaders.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

enum HTTPHeaders {
    case json
    case multipartFormData(boundary: String)
    case identifier
        
    var key: String {
        switch self {
        case .json:
            return "Content-Type"
        case .multipartFormData:
            return "Content-Type"
        case .identifier:
            return "identifier"
        }
    }
    
    var value: String {
        switch self {
        case .json:
            return "application/json"
        case .multipartFormData(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        case .identifier:
            return "eef3d2e5-0335-11ed-9676-e35db3a6c61a"
        }
    }
}
